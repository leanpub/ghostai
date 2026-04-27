# GhostAI Config Hierarchy

GhostAI looks for your voice profile, style guide, learnings, and reviews in
three places. The first match wins. Nothing is merged.

## The three tiers

| # | Tier | Where | Use it for |
|---|------|-------|------------|
| 1 | **Global** | `~/.ghostai/<file>` | Your machine-wide defaults. A voice you want to bring to every new book without re-uploading samples. |
| 2 | **Project-local** | `~/.ghostai/projects/{slug}/<file>` | Per-book state in your home directory. Doesn't follow the manuscript when you push to git. |
| 3 | **In-repo** | `{repo}/.ghostai/<file>` | Lives in the manuscript itself. Use this when co-authors should share the voice or style guide. |

`{slug}` is the basename of your manuscript's git root (or current directory).
`{file}` is one of `voice-profile.json`, `style-guide.md`, `learnings.jsonl`,
or the `reviews/` directory.

## How loading works

For each config independently, GhostAI looks in repo, then project-local, then
global. The highest tier that has a file wins, full stop. If you have a voice
profile in the repo and a different one in your global defaults, the repo's
profile is used and the global one is ignored — there is no merging.

When a skill loads a config, the run header tells you which tier it came from
in plain English, with the path shown as supplementary info.

## How saving works

When you create a voice profile or style guide for the first time (typically
via `/ghost-start` or `/ghost-voice`), GhostAI asks which tier to save to.
Your choice is recorded in `~/.ghostai/projects/{slug}/.tier` so subsequent
silent writes — each accepted style decision in `/ghost-edit`, each saved
review from `/ghost-review` — land in the same tier without re-prompting.

To change tiers later, run `/ghost-voice` and pick "promote" or "copy". To
override the prompt for scripted setups, set the environment variable
`GHOSTAI_DEFAULT_TIER=global|project|repo`.

## Recommended `.gitignore` for in-repo configs

When you keep configs in `{repo}/.ghostai/`, commit the shared ones and ignore
the personal/noisy ones. Drop this in `{repo}/.ghostai/.gitignore`:

```gitignore
# Commit voice-profile.json and style-guide.md so co-authors share them.
# Ignore personal artifacts.
reviews/
learnings.jsonl
.tier
```

Tweak to taste — some teams want learnings shared (it's a record of agreed
terminology), some don't.

## Picking a tier

- **Solo author, one machine** → project-local is fine. The default.
- **Solo author, multiple machines** → global, so you don't re-train your
  voice on every machine.
- **Co-authored book** → in-repo for voice and style guide. Personal
  preferences (learnings) can stay project-local.
- **Trying a new voice for one book** → in-repo overrides whatever you have
  globally for just this manuscript.
