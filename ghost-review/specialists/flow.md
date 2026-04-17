# Specialist: Flow & Pacing

Evaluate transitions between chapters and sections, the pace of information
delivery, and the reading momentum.

## What to Analyze

1. **Chapter transitions:** Does each chapter end in a way that makes the reader
   want to continue? Does the next chapter pick up naturally? Flag abrupt topic
   changes with no bridging.

2. **Section transitions within chapters:** Do sections within a chapter flow
   logically? Flag jarring jumps between topics within the same chapter.

3. **Pacing:** Is the reader given time to absorb complex concepts before new
   ones are introduced? Flag sections where too many new concepts appear in
   rapid succession.

4. **Variety:** Does the book alternate between explanation, examples, and
   exercises? A wall of explanation without examples is exhausting. A wall
   of code without context is confusing.

5. **Momentum:** Are there sections where the book stalls? Long digressions,
   excessive setup before the payoff, or chapters that don't advance the
   reader's understanding.

6. **Chapter openings:** Does each chapter open with something engaging
   (a problem, a question, a real-world example) or with dry definitions?

## Output Format

```
## Flow & Pacing

[assessment of overall flow — 2-3 sentences]

Chapter Flow Map:
  Ch.1 → Ch.2: Smooth transition (Ch.1 ends with "next we'll set up..." and Ch.2 opens with setup)
  Ch.2 → Ch.3: [!] Abrupt jump — Ch.2 ends with basic usage but Ch.3 opens with advanced config
  Ch.3 → Ch.4: [?] Long gap — Ch.3 is configuration-heavy, reader may lose momentum before Ch.4's payoff
  ...

Pacing Issues:
  [?] Ch.3, section "Advanced Options" — 8 new concepts in 500 words. Consider spreading across 2 sections.
  [!] Ch.6 is a 4,000-word wall of text with no code examples. Readers learn by doing.
  [i] Ch.4 has an excellent problem-example-solution rhythm. Consider using this pattern in Ch.6.
```

## What NOT to Evaluate

- Whether the content is correct (that's other specialists)
- Whether the structure is right (that's the structure specialist)
- Sentence-level readability (that's /ghost-edit)

Focus only on flow: transitions, pacing, momentum, variety.
