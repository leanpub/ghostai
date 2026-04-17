# GhostAI Terminal Output Format

All GhostAI skills produce terminal output following these conventions.
Consistency across skills makes GhostAI feel like one product, not seven
separate tools.

## Skill Header

Every skill invocation starts with a boxed header:

```
┌─────────────────────────────────────────────────┐
│  GhostAI /ghost-review                          │
│  Manuscript: "Ansible for DevOps" (12 chapters) │
│  Total: 45,230 words (~3 hr read)               │
│  Voice: Technical-casual, second person          │
└─────────────────────────────────────────────────┘
```

Fields:
- Skill name (always `/ghost-[name]`)
- Book title (from first `#` heading in the first chapter, or Book.txt)
- Chapter count and total word count
- Reading time estimate (words / 250)
- Voice profile summary (or "not profiled yet")

## Section Headers

Use `##` Markdown headers for major sections within skill output:

```
## Structure Analysis
## Flow & Pacing
## Gaps & Missing Content
```

## Severity Markers

Three levels, used consistently across all skills:

```
[!] Critical — must fix before publish
[?] Suggestion — consider changing
[i] Note — informational, no action needed
```

Examples:
```
[!] Chapter 5 references a "users table" that chapter 3 calls "accounts table."
    Pick one name and use it consistently.

[?] This paragraph uses three consecutive transition words (Furthermore, Moreover,
    Additionally). Consider simplifying.

[i] Chapter 7 is your longest at 5,200 words (~21 min read). Not a problem,
    but readers may appreciate a break point around the midpoint.
```

## Cross-Chapter References

When referencing content across chapters, use this format:

```
Ch.3 → Ch.7: You introduce "dependency injection" in chapter 3 but chapter 7
assumes readers know "service locators" without explaining the relationship.
```

Always include:
- The source chapter and the target chapter
- The specific concept or text involved
- Why it matters to the reader

## Edit Suggestions (/ghost-edit batch format)

Group suggestions by type. Number them sequentially across groups.
Show the line number, the current text, and the suggested change.

```
GRAMMAR (3 suggestions)
  1. [line 42] "their" → "there"
     Your sentence: "Put their code in the src/ directory."

  2. [line 89] Missing comma after introductory clause
     "When the server starts the application loads config."
     → "When the server starts, the application loads config."

  3. [line 156] Run-on sentence — split at "however"

CLARITY (2 suggestions)
  4. [line 23] Passive voice: "was implemented" → "you implement"

  5. [line 67] Ambiguous pronoun: "it" could refer to the API or the client

TONE (0 suggestions)
  Your tone is consistent throughout this chapter. Nice work.

Apply: type "all" to apply everything, specific numbers (e.g., "1,2,4"),
or "skip" to apply nothing.
```

## Pre-flight Checklist (/ghost-edit appendix)

```
PUBLISH READINESS
  [✓] No placeholder text (TODO/TBD/FIXME)
  [✗] 1 broken reference: [Chapter 5 link](#ch5) — ch5 id doesn't exist
  [✓] Code samples complete (no empty fences)
  [!] Chapter is 4,200 words (2.1x your average) — consider splitting
  [✓] Valid Markua syntax
```

## Manuscript Dashboard (/ghost-status format)

```
Chapter              Words   Read     Last Edit     Status
───────────────────  ─────   ──────   ──────────    ──────
1. Introduction       2,100    8 min   2 hrs ago    ✓
2. Getting Started    3,400   14 min   1 day ago    ✓
3. Configuration      4,200   17 min   3 days ago   [!] 2x avg
4. Deployment         1,800    7 min   5 min ago    ✓ new
5. (empty)                0    0 min   —            [?] empty
───────────────────  ─────   ──────   ──────────
Total               11,500   46 min

Voice: Technical-casual, second person (profiled)
Style guide: 12 patterns documented

Est. API costs:
  /ghost-review (full manuscript): ~$1.20
  /ghost-edit (per chapter, avg):  ~$0.30
```

## Completion Status

Every skill ends with a completion block:

```
STATUS: DONE
Skill: /ghost-review | Time: 45s | Tokens: ~85K | Est. cost: ~$1.30
```

Status values:
- `DONE` — completed successfully
- `DONE_WITH_CONCERNS` — completed, but flagged issues for attention
- `NEEDS_CONTEXT` — couldn't complete, missing information (explain what)
- `BLOCKED` — couldn't proceed (explain why)

## Formatting Rules

- Use ASCII box drawing for the skill header (┌─┐│└─┘)
- Use ─── lines for table separators
- Use consistent indentation (2 spaces for nested content)
- Keep line width under 80 characters where possible
- Use Markdown formatting (bold, headers) for structure
- Don't use colors or ANSI escape codes (not portable across terminals)
- Don't use emoji (terminal, not chat)
