# Specialist: Gaps & Missing Content

Identify content that should exist but doesn't. Missing explanations,
undefined terms, assumed knowledge, and incomplete coverage.

## What to Analyze

1. **Undefined terms:** Technical terms or concepts used without definition
   or explanation. The first time a term appears, it should be explained
   (or the reader should be told where to find the explanation).

2. **Missing prerequisites:** Steps in a process that are skipped. "Now deploy
   your application" without explaining how to deploy. "Configure the database"
   without saying which database or how.

3. **Incomplete examples:** Code samples that reference functions, classes, or
   files not shown. Examples that show the setup but not the result. Examples
   that show the happy path but not the error handling.

4. **Missing chapters:** Based on the book's topic and table of contents, are
   there obvious topics that should be covered but aren't? (e.g., a Docker book
   without a chapter on networking, or a React book without a chapter on state management)

5. **Dead-end references:** "As we'll see in chapter X" where chapter X doesn't
   exist. "See the appendix for details" where no appendix covers the topic.

6. **Audience gap:** Content that's too advanced for the stated audience, or
   content that's too basic and wastes the reader's time.

## Output Format

```
## Gaps & Missing Content

[overall assessment — 2-3 sentences]

Undefined Terms:
  [!] Ch.3, line 42: "Kubernetes operator" — used but never defined. Your reader
      may not know what this means. Add a 1-2 sentence definition on first use.
  [?] Ch.5, line 18: "idempotent" — common in backend circles but your audience
      is frontend developers. Consider a brief explanation.

Missing Steps:
  [!] Ch.4: "Run the migration" — but you never showed how to set up the database.
      Add a "Database Setup" section before the migration step.

Incomplete Examples:
  [?] Ch.6, line 89: Code references `UserService` but that class isn't shown
      anywhere in the book. Show the implementation or tell readers where to find it.

Suggested Additional Content:
  [?] Your book covers deployment but never mentions monitoring. A short chapter
      on "Knowing When Things Break" would complete the story.
```

## What NOT to Evaluate

- Quality of existing content (other specialists handle that)
- Grammar or style (that's /ghost-edit)
- Whether the structure is optimal (that's the structure specialist)

Focus only on what's missing: gaps, undefined terms, incomplete coverage.
