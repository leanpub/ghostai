# GhostAI

> *Imagine a world where every author has a writing partner who never gets tired,
> never breaks the voice, and never leaves until the chapter is done.*

GhostAI is an MIT-licensed toolkit of AI skills that runs inside
[Claude Code](https://claude.com/claude-code). You install it on your own laptop.
It works on your own manuscript. The AI calls go through your own Claude account.

Most AI writing tools generate slop. GhostAI keeps your voice. It reads your full
manuscript structure, maintains context across chapters, and edits in place — no
copy-paste, no browser window. The AI works where you work.

## Install

**Step 1 — Clone the repo into your Claude skills directory.**

SSH (recommended if you have GitHub SSH keys set up):

```bash
git clone git@github.com:leanpub/ghostai.git ~/.claude/skills/ghostai
```

HTTPS:

```bash
git clone https://github.com/leanpub/ghostai.git ~/.claude/skills/ghostai
```

**Step 2 — Run the install script.**

```bash
~/.claude/skills/ghostai/install.sh
```

The script creates symlinks so Claude Code discovers each `/ghost-*` command.
No build step, no binaries, no Python or Node dependencies. If you can `git clone`,
you can install GhostAI.

**Step 3 — Verify.**

Open Claude Code in any directory and run `/ghost-status`. If you see a dashboard
(even a mostly-empty one), you're set.

**To update later:** `cd ~/.claude/skills/ghostai && git pull && ./install.sh`

### Requirements

- [Claude Code](https://claude.ai/code) (or any SKILL.md-compatible agent: Cursor, Gemini CLI, Codex CLI)
- An Anthropic API key (or API key for your agent)
- macOS, Linux, or WSL2 on Windows
- A manuscript in Markua format (or run `/ghost-start` to create one)

### Troubleshooting

Three gotchas account for most install problems:

1. **Corporate proxies** block the `git clone`. Ask your network admin to whitelist
   `github.com`, or clone from a personal network.
2. **Missing SSH keys.** Use the HTTPS clone URL — no keys needed.
3. **Windows on plain PowerShell.** Install WSL2 and run the Linux commands from
   inside it. PowerShell can host Claude Code, but GhostAI assumes a POSIX shell.

## The Loop

The whole toolkit hangs off **The Loop** — a repeatable cycle that takes a chapter
from idea to publish. Get this and you've got the spine of GhostAI.

1. **Start once.** Define the book — topic, audience, voice. This happens once per
   book, not once per chapter. → `/ghost-start`
2. **Outline each chapter.** Push your structure past your first instinct. →
   `/ghost-outline`
3. **Pick your path.** Three doors out of the empty file — choose the one that
   matches your state. → `/ghost-draft`, `/ghost-expand`, or `/ghost-interview`
4. **Edit, or rewrite.** Polish line by line with `/ghost-edit` — that's where most
   of your time will go. Escalate to `/ghost-rewrite` when a section is structurally
   wrong, not just rough.
5. **Review when ready.** Once you have three or more chapters, take the cross-cutting
   view. → `/ghost-review`
6. **Publish.** Generate a Leanpub preview, ship it, repeat.

Steps 2–4 are the **chapter loop** — you go around them for every chapter. Steps 5–6
are the **manuscript loop**. Step 1 is the only one you do once.

```
                   /ghost-start
                         │
                         ├──optional──→  /ghost-voice
                         │                     │
                         │                     ▼
                         │               /ghost-train
                         │                     │
                         ├◄────────────────────┘
                         ▼
                  /ghost-outline
                         │
                         ▼
          ┌──────────────┼──────────────┐
          │              │              │
     /ghost-draft   /ghost-expand   /ghost-interview
     "blank page,   "I have notes  "I know this in my head
     tell me what    but they      but I can't get it on
     it could be"    won't grow"   the page in my voice"
          │              │              │
          └──────────────┴──────────────┘
                         │
                         ▼
              /ghost-edit  ⇄  /ghost-rewrite
              (line-level)     (section-level —
                                when polish isn't enough)
                         │
                         ▼
                /ghost-review  (after 3+ chapters)
                         │
                         ▼
                      publish

/ghost-status — the heartbeat. Run between every step.
```

## The Three Doors

The hardest moment in The Loop is the empty chapter file. GhostAI gives you three
doors out of it. They're not sequential steps — they're alternates. Pick the one
that matches the state you're actually in.

**`/ghost-draft`** — when you have a *blank page.* A chapter title, maybe some
outline notes, and nothing else. `/ghost-draft` interviews you about what the
chapter should do, then generates a first draft you can react to. The AI proposes.
You react. The draft doesn't have to be good. It has to exist.

**`/ghost-expand`** — when you have *notes that won't grow.* Bullets in a notes
app, outline points, a half-paragraph you wrote on the train. The text is there but
it won't turn into prose. `/ghost-expand` reads what you have, asks for the missing
connective tissue, and turns the bullets into paragraphs. You wrote the bones. The
AI grows the meat.

**`/ghost-interview`** — when you *know it cold but the prose won't sound right.*
You can talk about it for an hour at a meetup, answer any question a colleague asks.
But every time you try to write it down, it sounds like someone else.
`/ghost-interview` flips the script: the AI asks short questions, you answer in your
own words (typed, or dictated through speech-to-text like Wispr Flow), and the AI
weaves what you actually said into prose. The words are literally yours.

You can use a different door for every chapter. The chapter you draft today, you
might expand tomorrow, and interview the day after that. If a skill produces
something you don't recognize as your voice, stop — don't fight the prose. Run
`/ghost-interview` instead. The interview path is the strongest voice match because
the words are literally yours.

## The Daily Ritual

Writing is rewriting. The first draft of every chapter is a punching bag. The second
pass starts to feel like writing. The third pass is where the chapter becomes good.
By the tenth pass, the chapter is finally yours.

Here's what a writing morning looks like with GhostAI:

1. **Open Claude Code and run `/ghost-status`.** See exactly what you finished
   yesterday and which chapter is empty next.
2. **Pick your door.** Blank file → `/ghost-draft`. Bullets that won't grow →
   `/ghost-expand`. Know it cold but it won't sound right → `/ghost-interview`.
3. **Run `/ghost-edit`.** Polish until you'd ship it. If a section keeps not working
   line by line, escalate once with `/ghost-rewrite`.
4. **Run `/ghost-status` again.** Word count up, voice profile holding, one more
   chapter polished.

That's it. The Loop is the toolkit, repeated. Every morning. Every chapter.

## Skills

### Getting Started

**`/ghost-start`** — The topic interview. Run it once, at the very beginning, when
you have a book idea but not yet a book. It challenges your topic ("Developers"
isn't an audience. "AI" isn't a topic.), generates a starter outline, scaffolds the
manuscript, and extracts a voice profile from a writing sample you provide. That
voice profile is what keeps everything sounding like you instead of like a model.

**`/ghost-outline`** — Deep structure work. Goes beyond the starter outline from
`/ghost-start`: challenges every chapter to earn its place, finds the chapter your
reader needs that you didn't think of, and catches symmetry problems (real books
have heavy chapters and light chapters). Run it every time you sit down to think
about your book's structure.

### Writing

**`/ghost-draft`** — Blank page to first draft. Interviews you about what the
chapter should do, proposes a section-by-section plan, gets your approval on each
approach before writing any prose, then drafts it.

**`/ghost-expand`** — Bullets to prose. Takes rough notes, outline points, or
stream-of-consciousness jotting and grows them into finished paragraphs. Preserves
your intent and phrasing where it works, smooths what doesn't.

**`/ghost-interview`** — Talk your chapter into existence. The AI asks short,
voice-input-friendly questions. You answer in your own words. The transcript becomes
prose with your verbatim phrasing leading. The strongest voice match of the three
doors, because the words are literally yours.

### Editing

**`/ghost-edit`** — The daily driver. The command you'll run more than any other.
A copy editor for one chapter at a time that runs six specialist passes: grammar,
clarity, tone and voice consistency, technical accuracy, advisory AI slop detection
(flagged, never auto-fixed), and a pre-flight publish checklist. Every change is a
suggestion you accept or reject — like a real editor working in track changes.

**`/ghost-rewrite`** — Section-level structural revision. For when a passage exists
but the staging is wrong — unclear POV, buried lead, wrong order of ideas. Diagnoses
the structural bug first (the value is in articulating *what's actually wrong*),
then proposes two structurally different rewrites so you pick the angle rather than
nudge your way into it. If you find yourself reaching for `/ghost-rewrite` more
than once a chapter, your outline is probably the real problem — go back to
`/ghost-outline`.

### Review

**`/ghost-review`** — The development editor. Reads your *entire* manuscript, not
just a chapter. Catches the problems no individual `/ghost-edit` pass could catch:
a concept introduced in chapter 2 but defined in chapter 5, an argument that stalls
in the middle, the same point repeated three times across different chapters, pacing
that drags or rushes. This is where GhostAI's cross-chapter memory matters most.
Three triggers for running it: you just finished your third chapter, you're about to
publish a preview, or you haven't written in two weeks and you're picking the book
back up.

### Progress

**`/ghost-status`** — The heartbeat. A dashboard for your book at a glance: word
counts per chapter, estimated reading time, chapter balance, drafted versus outline.
Fast, free, and it tells you exactly where the book is. Run it between every step
of The Loop — the first command tomorrow and the last command tonight.

### Voice & Training

**`/ghost-voice`** — Manage your voice profile across machines, projects, and
co-authors. Update it from a fresh writing sample, promote it from your laptop into
the book's git repo so co-authors share the same voice, or copy it across machines.

**`/ghost-train`** — Teach GhostAI what you think about your own writing. Three
short interviews: what you're good at, where you struggle, and the patterns you
can't stand seeing on your page. Answers are synthesized into your style guide and
learnings so every other skill applies them automatically. Run it during onboarding,
after a tough edit session, or any time you want Ghost to internalize how you
actually think about your craft.

## Voice Preservation

The #1 complaint with AI writing tools is voice erasure. GhostAI addresses this at
every layer:

- **Voice profiling.** Analyzes your existing writing to extract style patterns —
  sentence length, vocabulary, tone, signature phrases.
- **Style guide.** Auto-generates a human-readable style guide from your manuscript.
- **Advisory slop detection.** Flags AI-generated patterns (unearned emphasis,
  formulaic transitions, empty attribution) without auto-correcting. You decide.
- **Direct quotes.** References your actual text in feedback, not abstractions.
- **Session memory.** Remembers terminology preferences and style decisions across
  sessions via a learnings file.

Your voice profile lives in one of three tiers (highest existing wins):

| Tier | Location | Use case |
|------|----------|----------|
| **Global** | `~/.ghostai/` | A voice you bring to every new book |
| **Project-local** | `~/.ghostai/projects/{slug}/` | Per-book on this machine |
| **In-repo** | `{repo}/.ghostai/` | Committable; co-authors share it |

GhostAI asks where to save when you first create the profile (during `/ghost-start`
or via `/ghost-voice`). Run `/ghost-voice` later to update, promote between tiers,
or share with co-authors. See
[`shared/config-hierarchy.md`](shared/config-hierarchy.md) for the full model.

## Manuscript Format

GhostAI expects [Markua](https://markua.com) format (Markdown for books), the
native format for [Leanpub](https://leanpub.com):

```
my-book/
  Book.txt          # Chapter manifest (one filename per line)
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

## Estimated API Costs

**Just use this with a Claude Pro or Claude Max plan. Seriously.**

Every GhostAI skill runs through Claude Code. On a Claude Pro or Claude Max plan,
your usage is already covered — the skills cost you nothing extra beyond the flat
monthly subscription. No per-token billing, no surprise invoices, no watching a
meter tick while you edit your book. A single `/ghost-review` pass on a full book
can burn through what a pay-as-you-go API user would consider a meaningful bill.
On a Claude plan it's just included.

(Note: these are **Anthropic's** Claude Pro / Claude Max subscription plans, not
Leanpub's author plans — unrelated products that share tier names.)

### Pay-as-you-go reference

If you're using the Anthropic API directly, rough costs for a 50,000-word
manuscript on Claude Sonnet:

| Skill | Per Run |
|-------|---------|
| `/ghost-review` | ~$1-2 |
| `/ghost-edit` | ~$0.20-0.50 per chapter |
| `/ghost-draft` | ~$0.50-1.00 per chapter |
| `/ghost-expand` | ~$0.10-0.30 per section |
| `/ghost-interview` | ~$0.30-0.80 per chapter |
| `/ghost-rewrite` | ~$0.15-0.40 per passage |
| `/ghost-status` | ~$0.10 |

Run `/ghost-status` for estimates specific to your manuscript.

## Cross-Agent Compatibility

GhostAI uses the universal SKILL.md format. While built and tested with Claude Code,
the same skill files work with other SKILL.md-compatible agents:

- Claude Code (primary, fully tested)
- Cursor
- Gemini CLI
- Codex CLI

Some interactive features may be simplified on non-Claude agents. The core writing
intelligence works everywhere.

## Project Structure

```
ghostai/
  ghost-start/SKILL.md         # Book onboarding wizard
  ghost-outline/SKILL.md       # Structured outline builder
  ghost-review/SKILL.md        # Development editor
  ghost-edit/SKILL.md           # Copy editor
  ghost-draft/SKILL.md          # First draft generator
  ghost-expand/SKILL.md         # Bullet-to-prose expander
  ghost-interview/SKILL.md      # Interview-driven writing
  ghost-rewrite/SKILL.md        # Section-level structural revision
  ghost-status/SKILL.md         # Manuscript dashboard
  ghost-train/SKILL.md          # Author self-assessment
  ghost-voice/SKILL.md          # Voice profile manager
  shared/                       # Shared skill infrastructure
    preamble-core.md            # Manuscript detection & loading
    resolve-config.sh           # 3-tier config resolver
    config-hierarchy.md         # Author-facing tier model
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

Found a bug? Have a feature request?
[File an issue](https://github.com/leanpub/ghostai/issues) or talk to us during
your Book Weekend or Boot Camp session.
