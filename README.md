# GhostAI

AI-powered writing skills for book authors. Built for [Leanpub](https://leanpub.com).

GhostAI operates at the filesystem level. It reads your full manuscript structure,
maintains context across chapters, and edits in place. No copy-paste. No context
limits. The AI works where you work.

## Install

**Step 1:** Clone the repo (pick one):

SSH (recommended if you have GitHub SSH keys set up):

```bash
git clone git@github.com:leanpub/ghostai.git ~/.claude/skills/ghostai
```

HTTPS:

```bash
git clone https://github.com/leanpub/ghostai.git ~/.claude/skills/ghostai
```

**Step 2:** Run the install script:

```bash
~/.claude/skills/ghostai/install.sh
```

The clone downloads the skill files. The install script creates symlinks so
Claude Code discovers each `/ghost-*` command. No build step, no binaries.

### Requirements

- [Claude Code](https://claude.ai/code) (or any SKILL.md-compatible agent: Cursor, Gemini CLI, Codex CLI)
- An Anthropic API key (or API key for your agent)
- macOS, Linux, or WSL2 on Windows
- A manuscript in Markua format (or run `/ghost-start` to create one)

## Skills

### Getting Started

| Skill | What it does |
|-------|-------------|
| `/ghost-start` | Creates your book: interviews you, generates an outline, scaffolds Markua files |
| `/ghost-outline` | Deep chapter planning: iterative Q&A to build a detailed outline |

### Writing

| Skill | What it does |
|-------|-------------|
| `/ghost-draft` | Generates a first draft from your outline in your voice |
| `/ghost-expand` | Turns bullet points and notes into polished prose |

### Editing

| Skill | What it does |
|-------|-------------|
| `/ghost-review` | Reads your entire book. Finds cross-chapter issues no human catches on first read. |
| `/ghost-edit` | Copy edits a single chapter: grammar, clarity, tone. Includes publish readiness checklist. |

### Progress

| Skill | What it does |
|-------|-------------|
| `/ghost-status` | Dashboard: word counts, reading times, chapter balance, estimated API costs |

## Quick Start

```bash
# 1. Start a new book
/ghost-start

# 2. Write your first chapter (you do this part)

# 3. Edit before publishing
/ghost-edit chapter-01.md

# 4. After writing 3+ chapters, get structural feedback
/ghost-review

# 5. Check your progress anytime
/ghost-status
```

## How It Works

GhostAI is a collection of SKILL.md files that extend Claude Code (and other
SKILL.md-compatible agents). Each skill is a Markdown document with instructions
for the AI. No compilation, no runtime dependencies.

### Manuscript Format

GhostAI expects [Markua](https://markua.com) format (Markdown for books):

```
my-book/
  Book.txt          # Chapter manifest
  introduction.md   # Chapters in Markua
  chapter-01.md
  chapter-02.md
  images/           # Image assets
```

`Book.txt` lists chapters in reading order:

```
{frontmatter}
introduction.md
{mainmatter}
chapter-01.md
chapter-02.md
{backmatter}
appendix.md
```

### Voice Preservation

The #1 complaint with AI writing tools is voice erasure. GhostAI addresses this:

- **Voice profiling:** Analyzes your existing writing to extract style patterns
- **Style guide:** Auto-generates a human-readable style guide from your manuscript
- **Advisory slop detection:** Flags AI-generated patterns without auto-correcting
- **Direct quotes:** References your actual text in feedback, not abstractions

Your voice profile and style guide are saved to `~/.ghostai/` and persist across sessions.

### What Makes GhostAI Different

Most AI writing tools work in a browser with copy-paste. GhostAI:

- **Reads your entire book.** Cross-chapter intelligence, not single-chapter snippets.
- **Edits in place.** No clipboard. Changes happen in your files.
- **Remembers across sessions.** Terminology preferences, style decisions, voice profile.
- **Speaks Markua.** Not generic Markdown. Validates and generates Leanpub-native syntax.
- **Respects your voice.** Suggests, never overwrites. You always decide.

## Cross-Agent Compatibility

GhostAI uses the universal SKILL.md format. While built and tested with Claude Code,
the same skill files work with other SKILL.md-compatible agents:

- Claude Code (primary, fully tested)
- Cursor
- Gemini CLI
- Codex CLI

Some interactive features (like chapter selection prompts) may be simplified on
non-Claude agents. The core writing intelligence works everywhere.

## Estimated API Costs

Costs depend on your manuscript size and the model you use. Rough estimates
for a 50,000-word manuscript on Claude Sonnet:

| Skill | Per Run |
|-------|---------|
| `/ghost-review` | ~$1-2 |
| `/ghost-edit` | ~$0.20-0.50 per chapter |
| `/ghost-draft` | ~$0.50-1.00 per chapter |
| `/ghost-expand` | ~$0.10-0.30 per section |
| `/ghost-status` | ~$0.10 |

Run `/ghost-status` for estimates specific to your manuscript.

## Project Structure

```
ghostai/
  ghost-start/SKILL.md         # Book onboarding wizard
  ghost-outline/SKILL.md       # Structured outline builder
  ghost-review/SKILL.md        # Development editor (5 specialists)
  ghost-edit/SKILL.md           # Copy editor (5 specialists)
  ghost-draft/SKILL.md          # First draft generator
  ghost-expand/SKILL.md         # Bullet-to-prose expander
  ghost-status/SKILL.md         # Manuscript dashboard
  shared/                       # Shared skill infrastructure
    preamble-core.md            # Manuscript detection & loading
    markua.md                   # Markua syntax cheat sheet
    anti-slop.md                # AI writing pattern detection
    voice.md                    # Editorial voice guidelines
    leanpub.md                  # Leanpub conventions
    output-format.md            # Terminal output formatting
    interaction-states.md       # Error/empty state handling
  CLAUDE.md                     # Skill routing rules
  README.md                     # This file
```

## License

MIT

## Feedback

Found a bug? Have a feature request? File an issue or talk to us during your
Book Weekend or Boot Camp session.
