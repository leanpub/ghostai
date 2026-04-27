# shellcheck shell=bash
# GhostAI config resolver — sourced by every skill's preamble.
#
# Resolves voice profile, style guide, learnings, and reviews across three tiers:
#   T1 global       ~/.ghostai/<file>
#   T2 project      ~/.ghostai/projects/{slug}/<file>
#   T3 in-repo      {repo}/.ghostai/<file>
#
# Highest existing tier wins on load. No merging.
#
# Inputs (must be set before sourcing):
#   GHOST_ROOT  — repository root (or current directory)
#   GHOST_SLUG  — basename of GHOST_ROOT
#
# Exports:
#   GHOST_TIER_GLOBAL, GHOST_TIER_PROJECT, GHOST_TIER_REPO
#   GHOST_VOICE_FILE, GHOST_VOICE_TIER         (repo|project|global|none)
#   GHOST_STYLE_FILE, GHOST_STYLE_TIER
#   GHOST_LEARNINGS_FILE, GHOST_LEARNINGS_TIER
#   GHOST_REVIEWS_DIR, GHOST_REVIEWS_TIER
#   GHOST_ANCHOR_TIER                          (where silent writes go)

GHOST_TIER_GLOBAL="$HOME/.ghostai"
GHOST_TIER_PROJECT="$HOME/.ghostai/projects/$GHOST_SLUG"
GHOST_TIER_REPO="$GHOST_ROOT/.ghostai"

# ghost_resolve_file <basename>
# Echoes "<path>|<tier>" for the highest existing tier.
# Echoes "|none" when the file does not exist anywhere.
ghost_resolve_file() {
  local name="$1"
  if [ -f "$GHOST_TIER_REPO/$name" ]; then
    echo "$GHOST_TIER_REPO/$name|repo"
  elif [ -f "$GHOST_TIER_PROJECT/$name" ]; then
    echo "$GHOST_TIER_PROJECT/$name|project"
  elif [ -f "$GHOST_TIER_GLOBAL/$name" ]; then
    echo "$GHOST_TIER_GLOBAL/$name|global"
  else
    echo "|none"
  fi
}

# ghost_resolve_dir <basename>
# Echoes "<path>|<tier>" for the highest tier where the directory exists
# AND contains at least one regular file. Echoes "|none" otherwise.
ghost_resolve_dir() {
  local name="$1"
  local d
  for tier_pair in "repo:$GHOST_TIER_REPO" "project:$GHOST_TIER_PROJECT" "global:$GHOST_TIER_GLOBAL"; do
    local tier="${tier_pair%%:*}"
    local base="${tier_pair#*:}"
    d="$base/$name"
    if [ -d "$d" ] && [ -n "$(ls -A "$d" 2>/dev/null)" ]; then
      echo "$d|$tier"
      return
    fi
  done
  echo "|none"
}

# ghost_tier_dir <tier>
# Echoes the base directory for a tier name.
ghost_tier_dir() {
  case "$1" in
    repo)    echo "$GHOST_TIER_REPO" ;;
    project) echo "$GHOST_TIER_PROJECT" ;;
    global)  echo "$GHOST_TIER_GLOBAL" ;;
    *)       echo "" ;;
  esac
}

# Resolve each config.
_pair=$(ghost_resolve_file "voice-profile.json")
GHOST_VOICE_FILE="${_pair%|*}"
GHOST_VOICE_TIER="${_pair#*|}"

_pair=$(ghost_resolve_file "style-guide.md")
GHOST_STYLE_FILE="${_pair%|*}"
GHOST_STYLE_TIER="${_pair#*|}"

_pair=$(ghost_resolve_file "learnings.jsonl")
GHOST_LEARNINGS_FILE="${_pair%|*}"
GHOST_LEARNINGS_TIER="${_pair#*|}"

_pair=$(ghost_resolve_dir "reviews")
GHOST_REVIEWS_DIR="${_pair%|*}"
GHOST_REVIEWS_TIER="${_pair#*|}"

# Anchor tier: where silent writes (learnings appends, saved reviews) land.
# Read from ~/.ghostai/projects/{slug}/.tier — project-local because that's
# the only path guaranteed to exist regardless of which tier the author chose.
# An env override (GHOSTAI_DEFAULT_TIER) wins over the pointer file, for
# scripted/non-interactive flows.
if [ -n "$GHOSTAI_DEFAULT_TIER" ]; then
  GHOST_ANCHOR_TIER="$GHOSTAI_DEFAULT_TIER"
elif [ -f "$GHOST_TIER_PROJECT/.tier" ]; then
  GHOST_ANCHOR_TIER=$(tr -d '[:space:]' < "$GHOST_TIER_PROJECT/.tier")
else
  GHOST_ANCHOR_TIER="project"
fi

# Sanity: clamp anchor to a known value.
case "$GHOST_ANCHOR_TIER" in
  repo|project|global) ;;
  *) GHOST_ANCHOR_TIER="project" ;;
esac

unset _pair tier_pair tier base d

export GHOST_TIER_GLOBAL GHOST_TIER_PROJECT GHOST_TIER_REPO
export GHOST_VOICE_FILE GHOST_VOICE_TIER
export GHOST_STYLE_FILE GHOST_STYLE_TIER
export GHOST_LEARNINGS_FILE GHOST_LEARNINGS_TIER
export GHOST_REVIEWS_DIR GHOST_REVIEWS_TIER
export GHOST_ANCHOR_TIER

# Natural-language source labels for header rendering.
# ghost_source_label <tier> — echoes a human phrase for a given tier.
ghost_source_label() {
  case "$1" in
    repo)    echo "from this book's repository" ;;
    project) echo "from your project's local store" ;;
    global)  echo "from your global defaults" ;;
    none)    echo "" ;;
    *)       echo "" ;;
  esac
}
