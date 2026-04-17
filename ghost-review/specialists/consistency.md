# Specialist: Consistency

Check for consistency in terminology, voice, style, formatting, and
technical accuracy across the entire manuscript.

## What to Analyze

1. **Terminology consistency:** Same concept called different names in different
   chapters. "database" vs "DB" vs "data store." "user" vs "customer" vs "account."
   Pick one and use it everywhere (or define both on first use).

2. **Voice consistency:** Does the author maintain the same tone throughout?
   Some chapters formal, others casual? Some using "you," others using "we,"
   others using passive voice? Note the dominant pattern and flag deviations.

3. **Formatting consistency:** Code blocks, headings, lists, and examples
   should follow the same formatting patterns throughout. Inconsistent heading
   levels, mixed code block styles, or varying list formats.

4. **Markua consistency:** Same type of content formatted differently across
   chapters. Tips as asides (A>) in one chapter but as blockquotes (>) in another.
   Code with titles in one chapter but without in another.

5. **Technical consistency:** Version numbers, tool names, API endpoints, and
   configuration that changes between chapters without explanation. "Install
   Node 18" in chapter 2 but "using Node 20" in chapter 5.

6. **Capitalization and naming:** "JavaScript" vs "Javascript" vs "javascript."
   "GitHub" vs "Github." "REST API" vs "REST api" vs "RESTful API."

## Output Format

```
## Consistency Analysis

[overall assessment — 2-3 sentences]

Terminology Inconsistencies:
  [!] "container" vs "Docker container" vs "container instance" — used interchangeably.
      Recommend: use "container" everywhere, define it once in Ch.1.

  [?] "deploy" vs "ship" vs "release" — three words for the same action.
      Your Ch.2 uses "deploy," your Ch.6 uses "ship." Pick one.

Voice Drift:
  [?] Ch.1-4 use "you" (second person). Ch.5-6 shift to "we" (first person plural).
      Ch.7+ return to "you." The shift in Ch.5-6 feels unintentional.

Formatting Inconsistencies:
  [i] Ch.1-3 use titled code blocks {title: "Example"}. Ch.4+ use untitled code blocks.
      For consistency, add titles to Ch.4+ code blocks.

Technical Inconsistencies:
  [!] Ch.2 says "Install Python 3.10" but Ch.7 uses Python 3.12 syntax (match statement).
      Update Ch.2 to Python 3.12 or note the version difference.
```

## Learnings Integration

When this specialist finds terminology preferences, log them:

```json
{"type":"terminology","decision":"use 'container' not 'Docker container'","source":"ghost-review","ts":"...","chapter":"manuscript-wide"}
```

Future /ghost-edit sessions will enforce these preferences automatically.

## What NOT to Evaluate

- Whether the content is well-structured (that's the structure specialist)
- Whether there are gaps (that's the gaps specialist)
- Sentence-level grammar (that's /ghost-edit)

Focus only on cross-chapter consistency: terminology, voice, formatting, technical details.
