---
name: ghost-voice
description: |
  Manage the voice profile across the three GhostAI config tiers (in-repo,
  project-local, global). View what's loaded, create or update at any tier,
  promote a profile from one tier to another, or delete one. Use when the
  author asks to "update voice", "change voice profile", "share voice with
  co-authors", "promote voice to repo", or "view voice profiles".
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Write
  - Edit
  - AskUserQuestion
---

# /ghost-voice — Voice Profile Manager

You manage the author's voice profile across GhostAI's three config tiers.
This skill is the canonical entry point for any voice-related operation that
isn't part of initial book onboarding.

See `shared/config-hierarchy.md` for the tier model. The short version:
- **In-repo** (`{repo}/.ghostai/voice-profile.json`) — committable, shareable
- **Project-local** (`~/.ghostai/projects/{slug}/voice-profile.json`) — per-book on this machine
- **Global** (`~/.ghostai/voice-profile.json`) — machine-wide default

Highest existing tier wins on load. No merging.

## Step 1: Run the Shared Preamble

Read `shared/preamble-core.md` and follow its instructions. The preamble
exports `$GHOST_VOICE_FILE`, `$GHOST_VOICE_TIER`, `$GHOST_TIER_REPO`,
`$GHOST_TIER_PROJECT`, `$GHOST_TIER_GLOBAL`, and the helpers
`ghost_tier_dir` and `ghost_source_label`.

## Step 2: Survey All Three Tiers

Don't just trust the resolver — show the author what exists at every tier
so they have a complete picture before deciding what to do:

```bash
echo "=== Voice profiles across tiers ==="
for tier in repo project global; do
  dir=$(ghost_tier_dir "$tier")
  file="$dir/voice-profile.json"
  if [ -f "$file" ]; then
    bytes=$(wc -c < "$file" | tr -d ' ')
    mtime=$(stat -f '%Sm' -t '%Y-%m-%d' "$file" 2>/dev/null || stat -c '%y' "$file" 2>/dev/null | cut -d' ' -f1)
    label=$(ghost_source_label "$tier")
    marker=""
    [ "$tier" = "$GHOST_VOICE_TIER" ] && marker=" ← active"
    echo "$tier: $bytes bytes, updated $mtime ($label)$marker"
  else
    echo "$tier: (none)"
  fi
done
```

For each existing profile, also read it and produce a one-line summary
(person, formality, average sentence length) so the author can compare
without opening files.

## Step 3: Pick the Action

Use AskUserQuestion to offer the operations:

> "What would you like to do with your voice profile?"
>
> - A) **View** — show the active profile in detail
> - B) **Create or update at a specific tier** — generate a profile from a
>      writing sample or analyze chapters, then save to the tier you choose
> - C) **Promote / copy to another tier** — copy an existing profile from
>      one tier to another (e.g., promote project-local to in-repo so
>      co-authors share it)
> - D) **Delete at a specific tier** — remove a profile, exposing whichever
>      tier sits below it

### A: View

Print the active profile (`$GHOST_VOICE_FILE`) with field-level explanations.
Lead with a natural-language summary, e.g.:

> "Your active voice profile comes from this book's repository
> (`.ghostai/voice-profile.json`). It says: second-person, conversational
> formality, average sentence length 18 words, occasional rhetorical
> questions, frequent code-first paragraphs."

If profiles exist at lower tiers and differ from the active one, mention
them: "You also have a different profile at the global tier — it's hidden
by the repo profile. Want to view, promote, or delete it?"

### B: Create or update

Ask the author for source material:

> "How should I build the voice profile?"
>
> - A) **From a writing sample** — paste text or share a file/URL
> - B) **From this manuscript's chapters** — analyze 2-3 chapters
> - C) **From a description** — tell me how you want to sound
>      (more casual, more authoritative, etc.)

Build the profile (extract sentence length, vocabulary, person, formality,
humor/anecdote/question patterns, paragraph length).

Then ask which tier to save to:

> "Where should I save the new voice profile?"
>
> - A) **In this book's repository** (`.ghostai/voice-profile.json`) — shared via git
> - B) **Project-local on this machine** (`~/.ghostai/projects/{slug}/voice-profile.json`)
> - C) **Global default for this machine** (`~/.ghostai/voice-profile.json`) — used everywhere

If `GHOSTAI_DEFAULT_TIER` is set, skip the prompt.

If a profile already exists at the chosen tier with different content, confirm
overwrite via AskUserQuestion before writing.

Write the file:

```bash
target_dir=$(ghost_tier_dir "$chosen_tier")
mkdir -p "$target_dir"
# Write target_dir/voice-profile.json
mkdir -p "$GHOST_TIER_PROJECT"
echo "$chosen_tier" > "$GHOST_TIER_PROJECT/.tier"
```

If `chosen_tier=repo` and `$GHOST_TIER_REPO/.gitignore` doesn't exist, create
the recommended one (see `shared/config-hierarchy.md`).

After writing, run the shadow check (Step 4).

### C: Promote / copy

Ask source and destination tiers:

> "Copy from which tier?" — list only tiers that have a profile.
> "Copy to which tier?" — list the other two tiers.

Read the source file, write byte-identical content to the destination
directory (`mkdir -p` first). Then run the shadow check (Step 4).

If the user says "promote" specifically (vs "copy"), offer to delete the
source after the copy completes — but ask first.

### D: Delete

Ask which tier to delete from. Warn if deleting will change which profile
is active (i.e., if deleting the highest tier reveals a lower-tier profile,
or removes the only profile entirely).

Use AskUserQuestion to confirm:

> "Delete the voice profile at the **{tier}** tier? This will {describe
> consequence — 'leave you with no voice profile' or 'fall back to the
> {next-tier} profile'}."

Then `rm` the file. If the deletion empties `$GHOST_TIER_PROJECT` of
everything except `.tier`, leave `.tier` alone (the anchor still applies
to learnings and reviews).

## Step 4: Shadow Check (after any write or copy)

If you just wrote a profile to a higher tier and a different-content profile
exists at a lower tier, that lower one is now invisible. Use AskUserQuestion
to surface this once:

> "You now have a voice profile at the **{higher-tier}** tier. Your
> **{lower-tier}** profile is different and is now shadowed (it won't be
> loaded). What should I do with it?"
>
> - A) Delete the shadowed profile — the new one is canonical
> - B) Keep both — I might want to switch back later
> - C) Show me the diff first

If the two profiles are byte-identical, silently delete the lower-tier copy
without asking (it's redundant).

No shadow check needed for `learnings.jsonl` or `reviews/` — those follow
`$GHOST_ANCHOR_TIER` rather than precedence.

## Step 5: Confirm and Complete

Show the final state:

```
┌─────────────────────────────────────────────────┐
│  GhostAI /ghost-voice                            │
│  Voice profile: {action taken}                   │
│  Active source: {tier} · `{path}`                │
└─────────────────────────────────────────────────┘
```

If the author created or moved a profile, suggest the natural next step:
"Run `/ghost-edit` on a chapter and the new voice will be applied."

```
STATUS: DONE
Skill: /ghost-voice | Action: {view|create|update|promote|delete} | Tier: {tier}
```
