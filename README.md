# Agentic HTML Docs — The Source-Complete Standard

An installable **Agent Skill** for authoring and validating **HTML-first, agent-readable
documentation**: one static HTML file that serves AI agents first and humans second — no
view-time JavaScript, no content duplication.

- **The skill:** [`source-complete-docs/skills/source-complete-docs/`](source-complete-docs/skills/source-complete-docs/)
- **The standard it teaches:** [`STANDARD.md`](source-complete-docs/skills/source-complete-docs/reference/STANDARD.md)
- **A conforming exemplar:** [`standard.html`](source-complete-docs/skills/source-complete-docs/templates/standard.html)
- **Status:** v0.1 draft (three open items tracked in `STANDARD.md §10`).

## What it does

Two workflows:
- **Author** a conforming doc (architecture overview, subsystem contract, API reference, data
  model, UI/wireframe spec, runbook, or the front-door index).
- **Validate** an existing doc against an 8-gate conformance checklist.

The five conformance rules in brief: (1) agents read the raw source; (2) source-complete, no
view-time JS; (3) content inline, CSS free; (4) faceted multi-axis `data-*` tags; (5) one
`data-source` + `data-verified` provenance primitive — plus *one shared toolkit + one construct
per doc type*.

---

## Install

### Claude Code (CLI / IDE) — as a plugin

```text
/plugin marketplace add george4data/agentic_html_doc
/plugin install source-complete-docs@agentic-html-doc
```

Or just ask Claude Code in the terminal:

> "Add the plugin marketplace `george4data/agentic_html_doc` and install the
> `source-complete-docs` plugin."

**Manual alternative** (no plugin system):

```bash
git clone https://github.com/george4data/agentic_html_doc.git
cp -R agentic_html_doc/source-complete-docs/skills/source-complete-docs \
      ~/.claude/skills/source-complete-docs
```

### Gemini CLI — as an extension

```bash
gemini extensions install https://github.com/george4data/agentic_html_doc
```

This loads [`GEMINI.md`](GEMINI.md), which points the agent at the skill's operating manual.

### Antigravity / other agentic IDEs

These don't have a fixed skill registry, but they're agent-driven, so point the agent at this
repo:

> "Clone `https://github.com/george4data/agentic_html_doc`, read
> `source-complete-docs/skills/source-complete-docs/SKILL.md`, and follow it whenever I ask you
> to write or validate agent-readable documentation."

If your tool supports Gemini-style extensions or an MCP/context-file mechanism, use
[`GEMINI.md`](GEMINI.md) as the context file (it's plain instructions, no platform-specific calls).

### claude.ai / Gemini app (web)

No GitHub auto-install in the web apps:
- **claude.ai:** upload the `source-complete-docs/skills/source-complete-docs/` folder in the
  Skills UI.
- **Gemini app:** create a Gem, paste the body of `SKILL.md` as instructions, and attach the
  `reference/` and `templates/` files as knowledge.

---

## Verify the install

Ask the agent:

> "Validate `templates/standard.html` against the Source-Complete Standard."

A correct install runs the validation workflow and returns a gate table with an overall
**CONFORMS** verdict — the bundled exemplar is conformant by construction.

## Repository layout

```
agentic_html_doc/
├── .claude-plugin/marketplace.json      ← Claude Code marketplace index
├── gemini-extension.json                ← Gemini CLI extension manifest
├── GEMINI.md                            ← Gemini context file
├── README.md
└── source-complete-docs/                ← the Claude Code plugin
    ├── .claude-plugin/plugin.json
    └── skills/
        └── source-complete-docs/        ← the skill
            ├── SKILL.md                 ← operating manual (author + validate)
            ├── reference/               ← STANDARD.md, facet-ontology, constructs, checklist
            └── templates/standard.html  ← conforming exemplar
```

## License

[MIT](LICENSE) — free to use, modify, and redistribute.

## Status

Draft v0.1. The base facet vocabulary, a reference author-time (Pandoc) build, and a
docs-specific conformance benchmark are open items — see `STANDARD.md §10`.
