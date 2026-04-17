# GhostAI Shared Preamble (Core)

Every GhostAI skill starts by running this preamble. It detects the manuscript,
reads the structure, loads persistence, and presents an overview.

## Manuscript Detection

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

# GhostAI persistence directory
GHOST_SLUG=$(basename "$GHOST_ROOT")
GHOST_DATA="$HOME/.ghostai/projects/$GHOST_SLUG"
mkdir -p "$GHOST_DATA"
echo "GHOST_DATA: $GHOST_DATA"

# Load learnings if they exist
if [ -f "$GHOST_DATA/learnings.jsonl" ]; then
  LEARN_COUNT=$(wc -l < "$GHOST_DATA/learnings.jsonl" | tr -d ' ')
  echo "LEARNINGS: $LEARN_COUNT entries"
else
  echo "LEARNINGS: 0"
fi

# Load voice profile if it exists
if [ -f "$GHOST_DATA/voice-profile.json" ]; then
  echo "VOICE_PROFILE: found"
else
  echo "VOICE_PROFILE: none"
fi

# Load style guide if it exists
if [ -f "$GHOST_DATA/style-guide.md" ]; then
  echo "STYLE_GUIDE: found"
else
  echo "STYLE_GUIDE: none"
fi
```

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
│  Voice: [profile summary or "not profiled yet"] │
└─────────────────────────────────────────────────┘
```

Reading time estimate: words / 250 (average reading speed for technical content).

## Load Learnings

If `LEARNINGS` count > 0, read `~/.ghostai/projects/{slug}/learnings.jsonl`.
Each line is a JSON object with fields: type, decision, source, ts, chapter.
Filter learnings relevant to the current skill's task.

Skills that edit text should load: terminology, style learnings.
Skills that review structure should load: structure learnings.
All skills should load: factual learnings.

When a learning applies, mention it: "Applying your style preference: 'dataset'
not 'data set' (from your last /ghost-edit session)."

## Voice Profile

If `VOICE_PROFILE` is found, read `~/.ghostai/projects/{slug}/voice-profile.json`.
Use it as a soft constraint for any text generation or editing suggestions.

If no voice profile exists and the skill needs one (ghost-edit, ghost-draft,
ghost-expand), note: "No voice profile yet. Run /ghost-start with a writing
sample, or I'll create one after analyzing 2-3 of your chapters."

## Single-Read Architecture

**IMPORTANT:** The preamble reads all chapters once during the overview step.
These chapters are now in the conversation context. Skills MUST NOT re-read
the same chapter files. Analyze from context. This avoids doubling the token
cost on every invocation.

The only exception: if a skill needs to write to a file, it should re-read
that specific file immediately before editing (to get the latest version).
