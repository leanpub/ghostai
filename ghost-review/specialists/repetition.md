# Specialist: Repetition Detection

Find redundant content across chapters: repeated explanations, duplicate
examples, concepts explained multiple times, and unnecessary overlap.

## What to Analyze

1. **Concept re-explanation:** The same concept explained in full more than once.
   A brief reminder ("as we saw in chapter 3") is fine. A full re-explanation
   is redundant. Flag the second occurrence and suggest replacing it with
   a cross-reference.

2. **Duplicate examples:** Similar code samples or examples that demonstrate
   the same concept. One good example is better than three mediocre ones.

3. **Repeated warnings/caveats:** "Be careful with X" appearing in multiple
   chapters. Consolidate into one thorough treatment and reference it elsewhere.

4. **Overlapping chapters:** Two chapters that cover substantially the same
   territory with different framing. This usually signals a structural problem.

5. **Copy-paste artifacts:** Paragraphs or sections that appear nearly verbatim
   in multiple places. Common when authors expand blog posts into books.

6. **Intentional repetition:** Some repetition is pedagogically useful
   (reinforcing key concepts, "recall from chapter 2..."). Flag it but note
   that it may be intentional.

## Output Format

```
## Repetition Analysis

[overall assessment — 2-3 sentences]

Cross-Chapter Redundancies:
  [?] "Docker containers vs VMs" explained in both Ch.1 (line 23) and Ch.4 (line 56).
      Ch.4's version is better. Replace Ch.1's with a brief mention and forward reference.

  [!] Ch.3 and Ch.7 both have a "Setting Up Your Environment" section with nearly
      identical content. Consolidate into Ch.3 and reference from Ch.7.

  [i] Ch.5 and Ch.8 both reference the CAP theorem. The repetition is appropriate
      here since they apply it to different contexts.

Duplicate Examples:
  [?] The "hello world" API example appears in Ch.2 (line 30) and Ch.4 (line 12).
      Ch.4 should build on the Ch.2 example, not restart from scratch.
```

## What NOT to Evaluate

- Whether repeated content is correct (that's other specialists)
- Whether the writing style varies between repetitions (that's /ghost-edit)
- Sentence-level redundancy within a single paragraph (that's clarity)

Focus only on cross-chapter and cross-section redundancy.
