#!/usr/bin/env bash
#
# GhostAI Installer
#
# Usage:
#   git clone git@github.com:leanpub/ghostai.git ~/.claude/skills/ghostai
#   ~/.claude/skills/ghostai/install.sh
#
# What it does:
#   Creates symlink directories in ~/.claude/skills/ for each ghostai skill,
#   so Claude Code (and other SKILL.md-compatible agents) can discover them.

set -euo pipefail

GHOST_AI_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$(dirname "$GHOST_AI_DIR")"

# Discover skills: any directory matching ghost-* that contains a SKILL.md
skills=()
for skill_dir in "$GHOST_AI_DIR"/ghost-*/; do
  [ -f "$skill_dir/SKILL.md" ] || continue
  skills+=("$(basename "$skill_dir")")
done

if [ ${#skills[@]} -eq 0 ]; then
  echo "Error: No ghost-* skills found in $GHOST_AI_DIR"
  exit 1
fi

echo "Installing GhostAI skills into $SKILLS_DIR..."
echo ""

for skill in "${skills[@]}"; do
  target="$SKILLS_DIR/$skill"
  mkdir -p "$target"

  # Remove existing symlink if present (idempotent)
  [ -L "$target/SKILL.md" ] && rm "$target/SKILL.md"

  ln -s "$GHOST_AI_DIR/$skill/SKILL.md" "$target/SKILL.md"
  echo "  /$skill -> linked"
done

echo ""
echo "Done. ${#skills[@]} skills installed."
echo "Open Claude Code and type /ghost-start to begin."
