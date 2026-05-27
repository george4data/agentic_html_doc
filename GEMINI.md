# Source-Complete Docs (Gemini context)

This extension provides a skill for **authoring and validating HTML-first, agent-readable
documentation** following *The Source-Complete Standard*.

When the user asks to write, generate, update, or validate documentation meant for AI agents
to read — or mentions source-complete HTML docs, faceted `data-*` tags,
`data-source`/`data-verified` provenance, CSS-only tabs, or a docs front-door index —
**follow the full operating manual in
[`source-complete-docs/skills/source-complete-docs/SKILL.md`](source-complete-docs/skills/source-complete-docs/SKILL.md)**.
Open its bundled `reference/` and `templates/` files as needed.

## The five rules that define conformance (summary)

1. **Consumption contract** — agents read the *raw `.html` source*, never a browser snapshot.
2. **Source-complete, no view-time runtime** — all content inline; no `<script>` runs at view time; nothing fetched to reveal content. (Author-time builds are fine.)
3. **Content inline, CSS free** — only styling may be externalized.
4. **Faceted multi-axis tags** — one un-duplicated region carries several orthogonal `data-*`/`class` facets from a governed vocabulary.
5. **One provenance primitive** — `data-source` + `data-verified` is the single trust mechanism.

Plus: **one shared toolkit + exactly one specialized construct per doc type.**

Two workflows are defined in the SKILL.md: **A — Author** a conforming doc, and **B — Validate**
a doc against the 8-gate conformance checklist (`reference/conformance-checklist.md`).
