# Anti-Slop Guardrails for GhostAI

These are advisory flags, not enforcement rules. When GhostAI detects these
patterns in generated or edited text, it flags them for the author's review.
The author always decides. A pattern that's "slop" in one context might be
deliberate craft in another.

## How to Use This File

Skills that generate text (ghost-draft, ghost-expand) should avoid these patterns
in their output. Skills that edit text (ghost-edit) should flag these patterns
in the author's existing text with [?] advisory markers.

Never auto-correct. Always explain why the pattern was flagged and offer an
alternative. The author may have a good reason.

## Pattern 1: Unearned Emphasis

Using intense vocabulary for ordinary concepts. The emphasis doesn't match
the significance of what's being described.

**Example (flagged):**
"This fascinating approach to error handling revolutionizes how we think about exceptions."

**Why it's flagged:** Error handling is useful, not fascinating. "Revolutionizes"
implies a paradigm shift that isn't happening here.

**Better:**
"This approach to error handling catches edge cases that try/catch misses."

**When it's NOT slop:** The author is genuinely describing something remarkable,
and can point to specific evidence of why it's remarkable.

## Pattern 2: Formulaic Transitions

Academic-style connecting words that add no information. They signal structure
instead of letting the ideas flow naturally.

**Example (flagged):**
"Furthermore, the API supports pagination. Moreover, it handles rate limiting.
Additionally, there is built-in caching."

**Why it's flagged:** Three consecutive academic transitions. The reader's eye
skips them anyway. They're filler, not connective tissue.

**Better:**
"The API supports pagination, handles rate limiting, and caches responses."

**When it's NOT slop:** Formal academic writing where these transitions are
genre-appropriate (rare in technical books, common in dissertations).

## Pattern 3: Punched-Up Parallelism

Dramatic contrasts constructed for rhetorical effect where the actual content
doesn't warrant drama. The "It's not X, it's Y" construction.

**Example (flagged):**
"It's not a database. It's a knowledge graph."
"This isn't just a feature. It's a paradigm shift."

**Why it's flagged:** The structure creates artificial drama. If the distinction
matters, state it plainly. If it doesn't, the parallelism is covering for
weak substance.

**Better:**
"It's a knowledge graph built on a relational database."

**When it's NOT slop:** The author is making a genuinely surprising distinction
that the reader needs reframing to understand.

## Pattern 4: Symmetry Addiction

Defaulting to balanced structures (exactly three items, two-part contrasts,
matched sentence lengths) regardless of whether the content has three things
to say.

**Example (flagged):**
"There are three key benefits: speed, reliability, and ease of use."
(followed later by)
"There are three main challenges: complexity, cost, and maintenance."
(followed later by)
"There are three approaches: manual, automated, and hybrid."

**Why it's flagged:** Not everything comes in threes. If there are four benefits,
say four. If there are two, say two. Forcing symmetry distorts the content.

**When it's NOT slop:** The author is using deliberate rhetorical structure
(e.g., a "three pillars" framework that's central to their argument).

## Pattern 5: Empty Attribution

Citing vague authority instead of specific sources. Makes claims sound
researched without actually providing evidence.

**Example (flagged):**
"Experts widely agree that microservices are the future."
"Studies have shown that test-driven development improves quality."
"Many developers believe that..."

**Why it's flagged:** Which experts? Which studies? Which developers?
Vague attribution is worse than no attribution because it creates
false confidence.

**Better:**
"Martin Fowler argues that microservices work best for large teams (monolith-first approach)."
Or just: "Microservices work well for large teams." (stated as opinion, honestly)

**When it's NOT slop:** The consensus is genuinely universal and well-known
(e.g., "most developers use version control" doesn't need a citation).

## Pattern 6: Mechanical Punctuation

Using the same punctuation pattern (especially em dashes) as a default
connector rather than varying sentence structure.

**Example (flagged):**
"The API is fast -- faster than most alternatives -- and it handles errors
gracefully. The SDK is simple -- just three methods -- and works on all
platforms. The docs are clear -- better than average -- and include examples."

**Why it's flagged:** Three consecutive sentences with the same em-dash
parenthetical structure. Reads like a template, not prose.

**Better:**
"The API is faster than most alternatives and handles errors gracefully.
The SDK exposes just three methods, all cross-platform. The docs include
examples for every endpoint."

**When it's NOT slop:** The author's established voice uses em dashes
frequently (check the voice profile first before flagging).

## Applying These Rules

When flagging a pattern, use this format:

```
[?] Possible AI-generated pattern detected (Pattern 2: Formulaic Transitions)
    Line 42: "Furthermore, the API supports..."
    Suggestion: Remove the transition word. The sentence is clear without it.
    Note: This may be intentional if you prefer formal academic style.
```

Key principles:
- Flag the pattern, not the word
- Always offer a concrete alternative
- Always acknowledge it might be intentional
- Never flag more than 5 anti-slop items per chapter (diminishing returns)
- Check the voice profile and style guide first -- if the author's established
  style includes a flagged pattern, don't flag it
