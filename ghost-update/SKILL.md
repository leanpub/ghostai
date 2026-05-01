---
name: ghost-update
description: |
  Update GhostAI to the latest version. Pulls the latest code from origin
  and re-creates skill symlinks. Run manually anytime, or GhostAI will
  prompt you once a day when updates are available.
allowed-tools:
  - Read
  - Bash
  - AskUserQuestion
---

# /ghost-update — Update GhostAI

You update GhostAI to the latest version. This is the simplest skill — run
the update script and report what happened.

## Step 1: Find the GhostAI Repo

Resolve the ghostai repo directory by following a skill symlink:

```bash
GHOSTAI_REPO=""
for skill_link in "$HOME/.claude/skills"/ghost-*/SKILL.md; do
  if [ -L "$skill_link" ]; then
    target=$(readlink "$skill_link" 2>/dev/null)
    if [ -n "$target" ]; then
      GHOSTAI_REPO=$(dirname "$(dirname "$target")")
      [ -d "$GHOSTAI_REPO/.git" ] && break
      GHOSTAI_REPO=""
    fi
  fi
done

# Fallback
[ -z "$GHOSTAI_REPO" ] && GHOSTAI_REPO="$HOME/.claude/skills/ghostai"

if [ ! -d "$GHOSTAI_REPO/.git" ]; then
  echo "ERROR: Cannot find GhostAI repo"
else
  echo "GHOSTAI_REPO: $GHOSTAI_REPO"
fi
```

If the repo can't be found, tell the author:
"Can't find the GhostAI installation. Expected it at `~/.claude/skills/ghostai/`.
Reinstall with: `git clone git@github.com:leanpub/ghostai.git ~/.claude/skills/ghostai && ~/.claude/skills/ghostai/install.sh`"

Then exit gracefully.

## Step 2: Check Current State

Show what version is currently installed and whether updates are available:

```bash
cd "$GHOSTAI_REPO"
CURRENT=$(git rev-parse --short HEAD)
BRANCH=$(git branch --show-current)
echo "CURRENT_COMMIT: $CURRENT"
echo "BRANCH: $BRANCH"

# Fetch to see what's available
git fetch origin --quiet 2>/dev/null
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main 2>/dev/null || echo "unknown")

if [ "$LOCAL" = "$REMOTE" ]; then
  echo "STATUS: up-to-date"
else
  BEHIND=$(git rev-list HEAD..origin/main --count 2>/dev/null || echo "?")
  echo "STATUS: $BEHIND commit(s) behind origin/main"
  echo ""
  echo "New commits:"
  git log --oneline HEAD..origin/main | sed 's/^/  /'
fi
```

If already up to date, show:

```
GhostAI is already up to date (commit {hash}).
```

Then exit — no need to run the update.

## Step 3: Confirm and Update

If updates are available, use AskUserQuestion:

> "{N} update(s) available for GhostAI:
>
> {list of commit messages}
>
> Update now?"
>
> - A) Yes, update
> - B) Skip for now

If the author chooses A, run the update script:

```bash
bash "$GHOSTAI_REPO/update.sh"
```

## Step 4: Report

Show the result:

```
┌─────────────────────────────────────────────────┐
│  GhostAI /ghost-update                          │
│  Updated: {old_hash} → {new_hash}               │
│  {N} new commit(s) pulled                       │
│  Skills re-linked                               │
└─────────────────────────────────────────────────┘
```

```
STATUS: DONE
Skill: /ghost-update | Commits: {N}
```
