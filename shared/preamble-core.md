# GhostAI Shared Preamble (Core)

Every GhostAI skill starts by running this preamble. It detects the manuscript,
resolves config across three tiers, and presents an overview.

## Manuscript Detection + Config Resolution

Run this bash block first:

```bash
# Detect manuscript directory
GHOST_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
GHOST_SKILL_DIR=$(dirname "$(dirname "$0")" 2>/dev/null || echo "$HOME/.claude/skills/ghost-ai")

# Find Book.txt (Leanpub manifest)
BOOK_TXT=""
if [ -f "$GHOST_ROOT/Book.txt" ]; then
  BOOK_TXT="$GHOST_ROOT/Book.txt"
elif [ -f "$GHOST_ROOT/manuscript/Book.txt" ]; then
  BOOK_TXT="$GHOST_ROOT/manuscript/Book.txt"
fi

# Detect manuscript base directory
if [ -n "$BOOK_TXT" ]; then
  MANUSCRIPT_DIR=$(dirname "$BOOK_TXT")
  echo "BOOK_TXT: $BOOK_TXT"
  echo "MANUSCRIPT_DIR: $MANUSCRIPT_DIR"
else
  # Fallback: look for .md files
  MD_COUNT=$(find "$GHOST_ROOT" -maxdepth 2 -name "*.md" -not -name "README.md" -not -name "CLAUDE.md" -not -path "*/.*" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$MD_COUNT" -gt 0 ]; then
    MANUSCRIPT_DIR="$GHOST_ROOT"
    echo "NO_BOOK_TXT"
    echo "MANUSCRIPT_DIR: $MANUSCRIPT_DIR (fallback: found $MD_COUNT .md files)"
  else
    echo "EMPTY_MANUSCRIPT"
  fi
fi

# Resolve config across global / project-local / in-repo tiers.
# Sets GHOST_VOICE_FILE, GHOST_VOICE_TIER, etc. See shared/config-hierarchy.md.
GHOST_SLUG=$(basename "$GHOST_ROOT")
# shellcheck source=resolve-config.sh
source "$GHOST_SKILL_DIR/shared/resolve-config.sh"

echo "GHOST_SLUG: $GHOST_SLUG"
echo "VOICE_PROFILE: $GHOST_VOICE_TIER${GHOST_VOICE_FILE:+ ($GHOST_VOICE_FILE)}"
echo "STYLE_GUIDE: $GHOST_STYLE_TIER${GHOST_STYLE_FILE:+ ($GHOST_STYLE_FILE)}"
echo "LEARNINGS: $GHOST_LEARNINGS_TIER${GHOST_LEARNINGS_FILE:+ ($GHOST_LEARNINGS_FILE)}"
echo "REVIEWS: $GHOST_REVIEWS_TIER${GHOST_REVIEWS_DIR:+ ($GHOST_REVIEWS_DIR)}"
echo "ANCHOR_TIER: $GHOST_ANCHOR_TIER"

# Check for GhostAI updates (at most once per day)
# shellcheck source=update-check.sh
source "$GHOST_SKILL_DIR/shared/update-check.sh"
```

## Update Check

If the preamble output includes `UPDATE_AVAILABLE`, surface it to the author
before proceeding with the skill:

"A GhostAI update is available ({N} new commits). Run `/ghost-update` to
install it, or continue with the current version."

Then proceed with the skill normally. Don't block on the update — it's
informational. The check runs at most once per 24 hours.

**No mkdir at read time.** The preamble used to create
`~/.ghostai/projects/{slug}/` unconditionally. It no longer does — directories
are created lazily by whichever skill actually writes (see "Writing config"
below).

**One file per config, no merging.** Each `$GHOST_*_FILE` variable holds a
single path — the file at the highest tier that has it. If a skill needs the
voice profile, it reads `$GHOST_VOICE_FILE` once and never looks at lower
tiers. Same for style, learnings, and reviews. The resolver's whole job is to
make this decision so skills don't have to.

## Interpret Results

**If `EMPTY_MANUSCRIPT`:** Tell the author:
"No manuscript found. Run `/ghost-start` to create your book structure, or create
some .md files and a Book.txt to get started."
Then exit the skill gracefully with STATUS: NEEDS_CONTEXT.

**If `NO_BOOK_TXT`:** Warn the author:
"No Book.txt found. Reading all .md files, but chapter order may be wrong.
Create a Book.txt to define your chapter order (one filename per line)."
Then proceed, reading .md files in alphabetical order.

**If `BOOK_TXT` found:** Read Book.txt to get chapter order. Each line is a filename
(relative to the manuscript directory). Blank lines and lines starting with `#` are
comments. Lines ending in `.md` are chapters. Lines like `{frontmatter}`, `{mainmatter}`,
`{backmatter}` are section markers.

## Read Manuscript Structure

After detecting the manuscript, read Book.txt and present an overview:

1. Read Book.txt line by line. For each .md filename:
   - Read the file using the Read tool
   - Count words (split on whitespace)
   - Extract the first heading (# line) as the chapter title
   - Note the file modification time

2. Present the overview using the standard skill header format:
```
┌─────────────────────────────────────────────────┐
│  GhostAI /[skill-name]                          │
│  Manuscript: "[book title]" ([N] chapters)      │
│  Total: [X] words (~[Y] hr read)                │
│  Voice: [source label or "not profiled yet"]    │
└─────────────────────────────────────────────────┘
```

For the Voice line (and any other config sources you want to surface), use
natural language with the path de-emphasized as inline code:

```
Voice: from this book's repository · `.ghostai/voice-profile.json`
```

Helper phrases by tier:
- `repo` → "from this book's repository"
- `project` → "from your project's local store"
- `global` → "from your global defaults"
- `none` → "not profiled yet"

(`shared/resolve-config.sh` provides `ghost_source_label <tier>` if you'd
rather call the helper directly.)

Reading time estimate: words / 250 (average reading speed for technical content).

## Load Learnings

If `$GHOST_LEARNINGS_TIER` is not `none`, read `$GHOST_LEARNINGS_FILE`. Each
line is a JSON object with fields: type, decision, source, ts, chapter, and
sometimes `apply` (a hint for how to use the entry). Filter learnings
relevant to the current skill's task.

Skills that edit text should load: terminology, style, strength, weakness,
dislike learnings.
Skills that draft or expand prose should load: terminology, style,
strength, weakness, dislike learnings.
Skills that review structure should load: structure, weakness learnings.
All skills should load: factual learnings.

The `strength`/`weakness`/`dislike` types come from `/ghost-train` and
capture the author's self-assessment of their craft. Use them as soft
constraints on generation and review:
- `strength` → lean in (preserve in edit, mirror when drafting)
- `weakness` → watch for (flag in edit, compensate when drafting)
- `dislike` → avoid (never generate; flag and strip when found)

If an entry has an `apply` field, prefer that hint over generic guidance.

When a learning applies, mention it: "Applying your style preference: 'dataset'
not 'data set' (from your last /ghost-edit session)."

## Voice Profile

If `$GHOST_VOICE_TIER` is not `none`, read `$GHOST_VOICE_FILE` (it lives at
the highest tier where a profile exists). Use it as a soft constraint for any
text generation or editing suggestions.

If no voice profile exists at any tier and the skill needs one (ghost-edit,
ghost-draft, ghost-expand), note: "No voice profile yet. Run /ghost-start
with a writing sample, or `/ghost-voice` to set one up at any tier (global,
project-local, or in-repo)."

## Writing config

When a skill creates or updates a config file, it must:

1. Decide the target tier. For voice/style: ask the author via
   AskUserQuestion (see `/ghost-voice` and `/ghost-start` for the canonical
   tier-selection prompt). For learnings/reviews: use `$GHOST_ANCHOR_TIER`.
2. Resolve the target directory with `ghost_tier_dir <tier>` from
   `resolve-config.sh`. Example:
   ```bash
   target_dir=$(ghost_tier_dir "$chosen_tier")
   mkdir -p "$target_dir"
   ```
3. Write the file. If the target tier is anything other than `project`, also
   create `$GHOST_TIER_PROJECT/.tier` with the chosen tier name so silent
   writes (learnings, reviews) follow the same anchor.

## Single-Read Architecture

**IMPORTANT:** The preamble reads all chapters once during the overview step.
These chapters are now in the conversation context. Skills MUST NOT re-read
the same chapter files. Analyze from context. This avoids doubling the token
cost on every invocation.

The only exception: if a skill needs to write to a file, it should re-read
that specific file immediately before editing (to get the latest version).
