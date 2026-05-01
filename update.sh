#!/usr/bin/env bash
#
# GhostAI Updater
#
# Usage:
#   ~/.claude/skills/ghostai/update.sh
#
# What it does:
#   Pulls the latest GhostAI from origin and re-creates skill symlinks.

set -euo pipefail

GHOST_AI_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Updating GhostAI..."
echo ""

cd "$GHOST_AI_DIR"

# Stash any local changes (shouldn't be any, but be safe)
if ! git diff --quiet 2>/dev/null; then
  echo "  Stashing local changes..."
  git stash --quiet
  STASHED=true
else
  STASHED=false
fi

# Pull latest
BEFORE=$(git rev-parse HEAD)
git pull --ff-only origin main 2>&1 | sed 's/^/  /'

AFTER=$(git rev-parse HEAD)

if [ "$BEFORE" = "$AFTER" ]; then
  echo ""
  echo "Already up to date."
else
  COMMITS=$(git rev-list "$BEFORE".."$AFTER" --count)
  echo ""
  echo "Pulled $COMMITS new commit(s):"
  git log --oneline "$BEFORE".."$AFTER" | sed 's/^/  /'
fi

# Restore stashed changes
if $STASHED; then
  echo ""
  echo "  Restoring local changes..."
  git stash pop --quiet
fi

# Re-create symlinks
echo ""
"$GHOST_AI_DIR/install.sh"
