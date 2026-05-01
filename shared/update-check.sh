# shellcheck shell=bash
# GhostAI update check — sourced by the preamble, runs at most once per day.
#
# Resolves the ghostai repo by following a skill symlink, fetches origin,
# and prints UPDATE_AVAILABLE if the local copy is behind.
#
# Outputs:
#   UPDATE_AVAILABLE: N new commit(s). Run /ghost-update or ~/.claude/skills/ghostai/update.sh
#   (nothing if up to date or checked within the last 24 hours)

_ghostai_update_check() {
  local repo=""
  local skill_link target

  # Follow a skill symlink back to the ghostai repo
  for skill_link in "$HOME/.claude/skills"/ghost-*/SKILL.md; do
    if [ -L "$skill_link" ]; then
      target=$(readlink "$skill_link" 2>/dev/null)
      if [ -n "$target" ]; then
        repo=$(dirname "$(dirname "$target")")
        [ -d "$repo/.git" ] && break
        repo=""
      fi
    fi
  done

  # Fallback to canonical install location
  [ -z "$repo" ] && repo="$HOME/.claude/skills/ghostai"
  [ -d "$repo/.git" ] || return 0

  local check_file="$HOME/.ghostai/.last-update-check"
  local now
  now=$(date +%s)

  # Skip if checked within the last 24 hours
  if [ -f "$check_file" ]; then
    local last age
    last=$(cat "$check_file" 2>/dev/null || echo "0")
    age=$(( now - last ))
    [ "$age" -lt 86400 ] && return 0
  fi

  # Record this check
  mkdir -p "$HOME/.ghostai"
  echo "$now" > "$check_file"

  # Fetch and compare
  git -C "$repo" fetch origin --quiet 2>/dev/null || return 0
  local local_head remote_head behind
  local_head=$(git -C "$repo" rev-parse HEAD 2>/dev/null) || return 0
  remote_head=$(git -C "$repo" rev-parse origin/main 2>/dev/null) || return 0

  if [ "$local_head" != "$remote_head" ]; then
    behind=$(git -C "$repo" rev-list HEAD..origin/main --count 2>/dev/null || echo "?")
    echo "UPDATE_AVAILABLE: $behind new commit(s). Run /ghost-update or ~/.claude/skills/ghostai/update.sh"
  fi
}

_ghostai_update_check
unset -f _ghostai_update_check
