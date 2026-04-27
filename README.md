# GhostAI

AI-powered writing skills for book authors. Built for [Leanpub](https://leanpub.com).

GhostAI operates at the filesystem level. It reads your full manuscript structure,
maintains context across chapters, and edits in place. No copy-paste. The AI
works where you work.

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

**`/ghost-start`** — A conversational onboarding for your book. GhostAI interviews you about your topic, your audience, and what you're trying to accomplish, then builds a full chapter outline and sets up your manuscript so you can start writing immediately. No blank page.

**`/ghost-outline`** — An in-depth chapter planning session. Goes beyond a flat table of contents: challenges your structure, asks what each chapter is really trying to do, and helps you decide what deserves a chapter versus what belongs as a section or a callout. Good for restructuring an outline you already have or building one from scratch.

### Writing

**`/ghost-draft`** — Turns an approved outline into a first-draft chapter that sounds like you. GhostAI analyzes your existing writing to profile your voice (sentence rhythm, vocabulary, tone) and uses that profile when drafting. You edit, rewrite, or keep whatever lands.

**`/ghost-expand`** — Takes rough notes, bullet points, or stream-of-consciousness jotting and expands them into finished prose. Preserves your intent and phrasing where it works, smooths what doesn't. Best when you know what you want to say but haven't put it into flowing sentences yet.

### Editing

**`/ghost-review`** — A development editor that reads your entire manuscript, not just a chapter. Catches the problems authors and beta readers miss on first pass: a concept introduced in chapter 2 but defined in chapter 5, an argument that stalls in the middle, the same point repeated three times across different chapters, pacing that drags or rushes. This is where GhostAI's cross-chapter memory matters most.

**`/ghost-edit`** — A copy editor for one chapter at a time. Catches grammar issues, flags awkward sentences, and suggests cleaner phrasing without flattening your voice. Runs a publish-readiness checklist before you ship: broken links, missing images, typos, inconsistent capitalization, placeholder text you forgot to fill in.

### Progress

**`/ghost-status`** — A dashboard for your book at a glance. Word counts per chapter, estimated reading time, chapter length balance (are any chapters three times longer than the rest?), how much is drafted versus still outline. Also estimates costs for running the other GhostAI skills against your current manuscript, so you can budget before kicking off a full review.

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

Your voice profile and style guide can live in any of three places, with the
highest existing tier winning on load (no merging):

1. **In your global defaults** — `~/.ghostai/voice-profile.json`. A voice you
   want to bring to every new book without re-uploading samples.
2. **In a project-local store** — `~/.ghostai/projects/{slug}/voice-profile.json`.
   Per-book on this machine, doesn't follow the manuscript when you push to git.
3. **In the manuscript's repo** — `{repo}/.ghostai/voice-profile.json`. Lives
   alongside your book so co-authors share the voice.

GhostAI asks where to save when you create the profile (during `/ghost-start`
or via `/ghost-voice`), and remembers your choice. Run `/ghost-voice` later to
update, promote between tiers, or share with co-authors. See
[`shared/config-hierarchy.md`](shared/config-hierarchy.md) for the full model.

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

**Just use this with a Claude Pro or Claude Max plan. Seriously.**

Every GhostAI skill runs through Claude Code, and if you're on a Claude Pro
or Claude Max plan your usage is already covered — the skills cost you nothing
extra beyond the flat monthly subscription. No per-token billing, no surprise
invoices, no watching a meter tick while you edit your book. If you're writing
a manuscript you'll be running these skills dozens or hundreds of times, and a
single `/ghost-review` pass on a full book can burn through what a pay-as-you-go
API user would consider a meaningful bill. On a Claude Pro or Claude Max plan
it's just included.

(Note: these are **Anthropic's** Claude Pro / Claude Max subscription plans for
Claude and Claude Code, not the Leanpub Pro / Leanpub Max author plans —
unrelated products that happen to share tier names.)

If you're not on Claude Pro or Claude Max yet, get on one of them before you
start writing. The plan pays for itself the first week you use GhostAI seriously.

### Pay-as-you-go reference (only if you insist)

If you're using the Anthropic API directly instead of a Claude subscription,
rough costs for a 50,000-word manuscript on Claude Sonnet:

| Skill | Per Run |
|-------|---------|
| `/ghost-review` | ~$1-2 |
| `/ghost-edit` | ~$0.20-0.50 per chapter |
| `/ghost-draft` | ~$0.50-1.00 per chapter |
| `/ghost-expand` | ~$0.10-0.30 per section |
| `/ghost-status` | ~$0.10 |

These add up fast across a whole book. Again: get a Claude Pro or Claude Max plan.

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
  ghost-voice/SKILL.md          # Voice profile manager (cross-tier)
  shared/                       # Shared skill infrastructure
    preamble-core.md            # Manuscript detection & loading
    resolve-config.sh           # 3-tier config resolver (sourced by preamble)
    config-hierarchy.md         # Author-facing tier model + .gitignore template
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
