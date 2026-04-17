# Specialist: Pre-flight Checklist

Run a "publish readiness" check on the chapter before the author hits publish.
Catches embarrassing issues that are easy to miss.

## What to Check

1. **Placeholder text:** Scan for markers that indicate unfinished content:
   - TODO, TBD, FIXME, XXX, HACK
   - "lorem ipsum" or placeholder text
   - Bracketed notes: [add example here], [need citation], [expand this]
   - Empty sections (heading followed by no content before next heading)

2. **Broken internal references:** Links to other chapters or sections that
   don't exist:
   - `[Chapter 5](#ch5)` where no element has id `ch5`
   - "As we saw in Chapter 8" when Chapter 8 doesn't exist in Book.txt
   - "See Appendix A" when no appendix exists

3. **Incomplete code samples:**
   - Empty code fences (``` with no content)
   - Code blocks with "..." or "// ..." indicating truncation
   - Code that references functions/variables not defined in the block
     and not explained in surrounding text

4. **Missing section headings:** Chapters over 2,000 words with no
   subheadings (## or ###). Long chapters without structure are hard
   to navigate.

5. **Chapter length relative to average:**
   - Flag if chapter is >2x the manuscript average: "[!] This chapter
     is [X] words (2.1x your average of [Y]). Consider splitting."
   - Flag if chapter is <0.5x average: "[?] This chapter is [X] words
     (0.4x your average). Consider expanding or merging with an adjacent chapter."

6. **Markua syntax issues:**
   - Raw HTML (Markua strips it — it won't render)
   - Invalid aside prefixes (only A>, W>, T>, E>, I>, Q>, X>, D> are valid)
   - Attributes on wrong line (must be immediately before the element)
   - Unclosed code fences
   - Images referencing files that should be checked for existence

## Output Format

Append this section after the edit suggestions:

```
PUBLISH READINESS
  [✓] No placeholder text (TODO/TBD/FIXME)
  [✗] 1 broken reference: [Chapter 5 link](#ch5) — ch5 id doesn't exist
  [✓] Code samples complete (no empty fences)
  [!] Chapter is 4,200 words (2.1x your average) — consider splitting
  [✓] Valid Markua syntax
  [✗] 1 raw HTML tag found: <br> on line 67 — Markua will strip this
```

Use [✓] for passing checks, [✗] for failing checks, and [!] for warnings.

## What NOT to Evaluate

- Grammar, clarity, or tone (other specialists handle those)
- Content quality or accuracy (that's technical-accuracy)
- Cross-chapter issues (that's /ghost-review)

Focus only on mechanical readiness: is this chapter publishable right now
without embarrassing mistakes?
