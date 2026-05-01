# Leanpub Conventions for GhostAI

GhostAI is purpose-built for Leanpub. This file describes the Leanpub author
workflow, manuscript conventions, and publishing philosophy that skills should
understand.

## Leanpub Philosophy: Publish Early, Publish Often

Leanpub authors publish their books chapter by chapter as they write them.
This means:

- Authors hit "publish" many times during the writing process
- Readers buy in-progress books and get updates as chapters are added
- Feedback comes in while the book is being written, not after
- The book is never "done" -- it's continuously improved

GhostAI skills should support this iterative loop:
  Write chapter → /ghost-edit → Publish → Write next chapter → Repeat

## Manuscript Directory Structure

Leanpub books use a `manuscript/` directory. Everything — manifests, chapters,
images — lives inside it. This is the canonical structure from Leanpub's own
sample book (https://github.com/leanpub/sample-leanpub-markdown-book):

```
my-book/
  manuscript/
    Book.txt              # Chapter manifest (reading order)
    Sample.txt            # Which chapters are in the free sample (optional)
    chapter-01.md         # Chapter files in Markua format
    chapter-02.md
    chapter-03.md
    images/               # Image assets (referenced as images/foo.png in Markua)
      diagram-01.png
      screenshot.jpg
    code/                 # External code samples (optional)
      example.rb
      demo.py
```

**`/ghost-start` must always scaffold into `manuscript/`.** GhostAI's preamble
also detects Book.txt at the repo root for backwards compatibility with older
projects, but new books should always use the `manuscript/` layout.

## Book.txt Format

```
{frontmatter}
preface.md
{mainmatter}
chapter-01.md
chapter-02.md
chapter-03.md
{backmatter}
appendix.md
```

- One filename per line
- `{frontmatter}`, `{mainmatter}`, `{backmatter}` are section markers
- Blank lines and `#` comments are ignored
- Files are relative to the directory containing Book.txt

## Sample.txt

Optional. Lists which chapters appear in the free sample that readers can
preview before purchasing. Same format as Book.txt (one filename per line),
but typically a subset:

```
chapter-01.md
chapter-02.md
```

When `/ghost-start` scaffolds a book, it creates a `Sample.txt` containing the
first chapter so the author has a working sample from day one.

## Leanpub Author Types

GhostAI primarily serves technical book authors:

- **Software developers** writing about tools, languages, frameworks
- **Consultants** writing to establish authority in their field
- **Educators** creating course materials and textbooks
- **Startup founders** documenting processes and knowledge

These authors are comfortable with:
- The terminal (they run Claude Code)
- Markdown/Markua syntax
- Git for version control
- Iterative publishing

They are typically NOT:
- Fiction writers
- First-time writers with no technical background
- Authors who need a WYSIWYG editor

## Leanpub Publishing Workflow

1. Author writes in Markua (.md files)
2. Author organizes chapters in Book.txt
3. Author pushes to GitHub/Bitbucket (or uses Leanpub's web editor)
4. Leanpub generates PDF, EPUB, and HTML from the Markua source
5. Readers get notified of updates
6. Author collects feedback and iterates

## Leanpub Royalty Model

- Authors keep 80% of every sale (Leanpub keeps 20%)
- Variable pricing: author sets a minimum and suggested price
- Readers can pay more than the suggested price
- Free books are possible (good for lead generation)

This matters for GhostAI because the financial incentive is real: a well-edited
technical book on Leanpub can generate significant revenue. The quality bar
matters because it directly affects the author's income.

## What GhostAI Should Know About Leanpub Authors

1. They're busy. Most are writing books alongside a full-time job.
2. They're experts in their domain but may not be expert writers.
3. They value speed. If /ghost-edit takes 5 minutes, they'll use it.
   If it takes 20 minutes, they won't.
4. They care about accuracy. A factual error in a technical book
   destroys credibility. Flag anything that looks wrong.
5. They publish incrementally. "Chapter 5 is ready" means "I want to
   publish chapter 5 today, not when the whole book is done."
