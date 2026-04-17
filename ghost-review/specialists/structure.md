# Specialist: Structure Analysis

Evaluate the manuscript's chapter organization and narrative arc.

## What to Analyze

1. **Chapter ordering:** Does the sequence make logical sense? Does each chapter
   build on knowledge from previous chapters, or does it assume knowledge that
   hasn't been introduced yet?

2. **Prerequisites:** For each chapter, what concepts must the reader already know?
   Are those concepts introduced in earlier chapters? Flag any "forward references"
   where a chapter assumes knowledge from a later chapter.

3. **Part organization:** If the book uses parts ({class: part} in Markua), do the
   parts group related chapters logically? Are parts balanced in size?

4. **Opening and closing:** Does the first chapter hook the reader? Does the last
   chapter provide closure or a clear next step?

5. **Chapter length balance:** Flag chapters that are >2x or <0.5x the average
   chapter length. Extreme variation can signal a chapter that should be split
   or merged.

6. **Progression:** Does complexity increase gradually? A technical book should
   start with fundamentals and build to advanced topics. Flag any sharp jumps
   in difficulty.

## Output Format

```
## Structure Analysis

[assessment of overall structure — 2-3 sentences]

Chapter Dependency Map:
  Ch.1 (Introduction) → standalone
  Ch.2 (Getting Started) → depends on Ch.1 concepts: [list]
  Ch.3 (Configuration) → depends on Ch.2 concepts: [list]
  ...

Issues:
  [!] Ch.5 assumes readers know "service mesh" but it's not introduced until Ch.8.
  [?] Ch.3 (4,200 words) is 2.1x your average. Consider splitting at [topic break].
  [i] Parts are well-balanced: Part 1 (3 chapters), Part 2 (4 chapters), Part 3 (3 chapters).
```

## What NOT to Evaluate

- Grammar, spelling, tone (that's /ghost-edit territory)
- Individual sentence quality (that's clarity/tone specialists)
- Code sample correctness (that's technical-accuracy)

Focus only on the macro structure: chapter organization, ordering, dependencies, balance.
