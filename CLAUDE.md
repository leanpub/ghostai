# GhostAI

GhostAI is a suite of Claude Code skills for book authors on Leanpub. It operates
at the filesystem level, reading your full manuscript structure, maintaining context
across chapters, and editing in place.

## Skills

| Skill | Purpose | When to use |
|-------|---------|-------------|
| `/ghost-start` | Book onboarding wizard | Starting a new book from scratch |
| `/ghost-outline` | Structured outline builder | Planning or restructuring chapters |
| `/ghost-review` | Development editor | After writing 3+ chapters, for structural feedback |
| `/ghost-edit` | Copy editor + pre-flight | Before publishing any chapter |
| `/ghost-draft` | First draft generator | Turning an outline into prose |
| `/ghost-expand` | Bullet-to-prose expander | Turning notes into polished text |
| `/ghost-status` | Manuscript dashboard | Checking progress anytime |

## Manuscript Format

GhostAI expects Leanpub-style manuscripts in Markua format:
- `Book.txt` — chapter manifest (one filename per line)
- `.md` files — chapters in Markua (Markdown for books)
- `images/` — image assets

## Persistence

GhostAI stores project data in `~/.ghostai/projects/{project-name}/`:
- `voice-profile.json` — extracted writing style characteristics
- `style-guide.md` — documented style preferences
- `learnings.jsonl` — terminology and style decisions from past sessions
- `reviews/` — saved review reports

## Skill Routing

When the user's request matches an available skill, ALWAYS invoke it using the Skill
tool as your FIRST action. Do NOT answer directly, do NOT use other tools first.

Key routing rules:
- "Start a book", "new book", "set up my manuscript" → invoke ghost-start
- "Outline", "plan chapters", "restructure" → invoke ghost-outline
- "Review my book", "structural feedback", "cross-chapter" → invoke ghost-review
- "Edit", "proofread", "check my chapter", "before I publish" → invoke ghost-edit
- "Write a draft", "generate a chapter", "draft from outline" → invoke ghost-draft
- "Expand", "flesh out", "turn bullets into prose" → invoke ghost-expand
- "Status", "progress", "how's my book", "word count" → invoke ghost-status
