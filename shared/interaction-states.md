# GhostAI Interaction States

Every skill must handle these states gracefully. The author should never hit
a dead end. Every state ends with an actionable next step.

## Universal States (all skills)

### Loading
While reading the manuscript and processing:
"Reading your manuscript ([N] chapters, [X] words)..."

### No Manuscript
When EMPTY_MANUSCRIPT is detected:
"No manuscript found in this directory. To get started:
  1. Run /ghost-start to create your book structure
  2. Or create .md files and a Book.txt manually
  3. Or cd into your manuscript directory and try again"

### No Book.txt
When manuscript files exist but no Book.txt:
"Found [N] .md files but no Book.txt. Reading files alphabetically.
For correct chapter ordering, create a Book.txt with one filename per line."

## /ghost-start States

### Success
"Your book is set up:
  Book.txt: [N] chapters listed
  Chapters: [list of .md files created]
  Voice: [profiled from sample / neutral default]
  Next: Start writing chapter 1, then run /ghost-edit when ready to publish."

### Manuscript Already Exists
"This directory already has a manuscript (Book.txt with [N] chapters).
  A) Add new chapters to your existing book
  B) Start a new book in a different directory
  C) Cancel"

### No Topic Provided
"I need to know what your book is about to generate an outline.
You can describe it in a sentence: 'A practical guide to Kubernetes for developers.'
Or run /ghost-outline for a deeper exploration of your topic."

### Voice Sample Not Available
"No writing sample provided. I'll use a neutral technical-book voice as default.
You can refine this later by providing a blog post, email, or any writing that
sounds like you. Run /ghost-start --refresh-voice when you have a sample."

## /ghost-outline States

### Success
"Here's your outline ([N] chapters, ~[X] estimated words):
[outline content]
Edit freely. When you're happy with the structure, run /ghost-start to create the files."

### No Topic
"What's your book about? I'll ask a few questions to build your outline:
  - Who is your reader?
  - What should they be able to do after reading?
  - What topics must you cover?"

### Existing Chapters Found
"You have [N] existing chapters. I'll read them to avoid duplication and find gaps.
[analysis of existing content]
Here's where your outline could grow: [suggestions]"

## /ghost-review States

### Success
Full report with all specialist sections.

### Empty Manuscript
"No chapters to review. Run /ghost-start to begin your book, or write your first
chapter and try again."

### Single Chapter
"Only 1 chapter found. I can review its internal structure, but cross-chapter
analysis needs at least 2 chapters. For chapter-level feedback, try /ghost-edit."

### Context Overflow (very large manuscripts)
"Your manuscript is [X] words. That's larger than I can analyze in full.
I'll use chapter summaries for the overview and analyze [target chapters]
in detail. Run /ghost-review on specific chapters for deep analysis."

## /ghost-edit States

### Success
Suggestion list + pre-flight checklist + apply prompt.

### No Chapter Specified
"Which chapter would you like me to edit?
  1. introduction.md (2,100 words)
  2. chapter-01.md (3,400 words)
  3. chapter-02.md (4,200 words)
Type a number, or a filename:"

### Empty Chapter
"chapter-03.md is empty (0 words). Nothing to edit yet.
Try /ghost-draft to generate a first draft from an outline,
or /ghost-expand to turn your notes into prose."

### File Not Found
"File not found: chapter-05.md
Your Book.txt lists these chapters: [list]
Check the filename and try again."

### No Suggestions
"No edits to suggest. Your chapter is clean.
Run /ghost-review for structural feedback, or publish as-is."

### Author Rejects All Suggestions
"No edits applied. Your chapter stands as written.
Run /ghost-review for structural feedback, or publish as-is."

## /ghost-draft States

### Success
"Draft created: draft-[slug]-[timestamp].md ([X] words)
This is a starting point, not a finished chapter. Review it,
edit freely, then run /ghost-edit when it's ready to publish.
The file is NOT added to Book.txt yet. Add it when you're satisfied."

### No Outline
"I need an outline to draft from. You can:
  1. Run /ghost-outline to build one interactively
  2. Point me to an outline file: /ghost-draft outline.md
  3. Describe what this chapter should cover"

### No Voice Profile
"No voice profile found. I'll draft in a neutral technical-book style.
For voice-matched drafts, run /ghost-start with a writing sample first,
or write 2-3 chapters manually so I can learn your voice."

## /ghost-expand States

### Success
"Expanded [N] bullet points into [X] words of prose.
The expansion is in your file, marked with comments.
Review the expanded text and edit to taste."

### No Bullets Found
"I didn't find bullet points or notes to expand in this file.
I'm looking for: bullet lists, incomplete sentences, bracketed notes like
[TODO: explain X], or short fragments that need fleshing out.
Point me at the right section or file."

### Partial Expansion
"Expanded [M] of [N] items. Skipped [K] items that were already
full prose. The expanded sections are marked with comments."

## /ghost-status States

### Success
Full dashboard table with all metrics.

### Empty Manuscript
"No chapters found. Your book is waiting to be written.
  /ghost-start — set up your book structure
  /ghost-outline — plan your chapters"

### Partial Manuscript (some chapters empty)
Show the dashboard with empty chapters marked:
"[?] 2 chapters in Book.txt are empty (0 words). Normal for in-progress books."
