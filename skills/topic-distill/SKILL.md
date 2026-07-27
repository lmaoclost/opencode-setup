---
name: topic-distill
description: "Extract key topics and concepts from a URL (YouTube video or blog post) and present them as a structured distilled list. Output goes to both chat and a markdown file in `3. Resources/raw-topics/`. Use when the user sends `/distill <url>` or asks you to 'distill this link', 'extract topics from this video', 'what is this article about', 'summarize the concepts in this link', or anything involving extracting structured ideas from a web source. Also trigger when user pastes a YouTube or article URL and asks what it covers. Does NOT create final zettelkasten notes — only topic extraction for the user to write their own notes."
---

# topic-distill

Extract topics and concepts from a URL (YouTube video or blog post/article). Present a structured list of distilled ideas in Portuguese. Save to `3. Resources/raw-topics/` in the user's Obsidian vault. **Do not generate final zettelkasten notes** — the user writes those themselves.

## Invocation

```
/distill <url> [--context "optional note about why this matters"]
```

The `--context` flag is optional. If provided, use it to prioritize or highlight topics relevant to the user's goal. The context also appears in the saved file's frontmatter.

## Supported Sources

| Source | Method |
|--------|--------|
| **YouTube** | Extract transcript via `yt-dlp` (must be in PATH). Prefer Portuguese subtitles first, fall back to English. |
| **Blog/Article** | Web fetch the page content. If paywalled or dynamic content blocks access, notify the user. |

## Output Format

The output goes to **both** the chat and a file. The file is saved at:

```
3. Resources/raw-topics/YYYY-MM-DD-slugified-title.md
```

Relative to the vault root: `C:\Users\renan\Documents\obsidian-backup`

### Chat Output

Present topics clearly in the chat after processing. Use this structure per topic:

```
### 1. [Concept Name]

**Explanation:**
(complete explanation — no artificial line limit. Write enough so the user understands the concept clearly and can create their own zettelkasten note from it)

**Timestamp:** 12:34  (YouTube only)

**Excerpt:**
> Literal quote from the source supporting the concept

**Tags:** #tag1 #tag2 #tag3
```

After listing all topics, add a **Connections** section:

```
## Connections
- **[Concept A]** ↔ **[Concept B]**: how they relate, complement, or contrast
- **[Concept C]** → foundation for **[Concept D]**
```

### Saved File Format

Use the exact template in `references/raw-topic-template.md`. The file must include frontmatter with source URL, collection date, type (youtube|blog), title, and optional context.

## Workflow

### Step 1 — Identify source type

- If the URL contains `youtube.com`, `youtu.be`, or `m.youtube.com` → YouTube
- Otherwise → blog/article

### Step 2a — YouTube: extract transcript

Run:
```powershell
yt-dlp --skip-download --write-auto-subs --sub-langs pt,en --output "%(id)s" "<url>"
```

This downloads subtitle files with the video ID as filename.

Read the `.pt.vtt` or `.en.vtt` file. **Parse VTT robustly:**
- Remove `WEBVTT` header and `Kind: captions` / `Language:` lines
- Remove sequence numbers (lines with only digits)
- Remove timestamp lines (`00:00:00.000 --> 00:00:03.000`)
- Remove inline timestamp tags: `<00:00:00.880><c>` and `</c>`
- Join fragmented text lines belonging to the same caption
- Result: clean paragraph text with speaker turns preserved

If Portuguese subtitles fail (429 rate limit, unavailable), **automatically fall back to English** without notifying the user unless both fail.

Clean up the VTT files after reading.

### Step 2b — Blog: fetch content

Use the available web fetch tool to get the page content. If the content is paywalled, behind a login, or requires JavaScript rendering to display meaningful text, tell the user:
> "Could not fully access this content — it appears to be [paywalled/dynamic/login-required]. Here is what I could retrieve: [partial content]."

### Step 3 — Analyze and distill topics

Read the full content carefully. Extract distinct concepts and ideas. Criteria:

- Each topic = one distinct concept, mechanism, framework, or insight
- Skip tangents, unsupported opinions, filler, repetition
- For each topic, identify:
  - A clear name for the concept
  - A thorough explanation (the user will write their own zettelkasten note from this)
  - Timestamp if YouTube (when the concept is discussed)
  - A literal quote/excerpt from the source
  - Relevant tags in Portuguese (e.g., #atencao #design #produtividade)
- At the end, identify connections between topics from the same source

### Step 4 — Present and save

1. Output the full distilled list to the chat
2. Save the file using the template format to `3. Resources/raw-topics/YYYY-MM-DD-slugified-title.md`

### Step 5 — Cleanup (YouTube only)

VTT files are deleted immediately after reading in Step 2a. No artifacts left.

## Rules

- **Language:** Everything in Portuguese (explanations, tags, connections section headers)
- **Quotes:** Literal excerpts from the source, formatted with `>` blockquote
- **Timestamps:** Include for YouTube, omit for blog
- **Explanation:** Complete enough for the user to write a zettelkasten note. No artificial limits.
- **Tags:** In Portuguese, extracted from the concept's domain
- **Connections:** Always include, even if brief
- **No notes:** Do not create actual zettelkasten notes. Do not search the vault for existing notes. Only distill topics.
- **No vault editing:** Do not modify any other files in the vault. Only write to `3. Resources/raw-topics/`.

## Configuration

Vault root: `C:\Users\renan\Documents\obsidian-backup`  *(adjust to your vault path)*
Raw topics directory: `3. Resources/raw-topics`
Language: Portuguese
YouTube subtitles priority: Portuguese → English (auto-fallback on 429/unavailable)