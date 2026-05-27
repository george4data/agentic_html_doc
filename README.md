# agentdocs — The Source-Complete Standard

An installable **Agent Skill** for authoring and validating **HTML-first, agent-readable
documentation**: one static HTML file that serves AI agents first and humans second — no
view-time JavaScript, no content duplication.

- **The skill:** [`skills/agentdocs/`](skills/agentdocs/)
- **The standard it teaches:** [`STANDARD.md`](skills/agentdocs/reference/STANDARD.md)
- **A conforming exemplar:** [`standard.html`](skills/agentdocs/templates/standard.html)
- **Status:** v0.1 draft (three open items tracked in `STANDARD.md §10`).

## What it does

Two workflows: **Author** a conforming doc (architecture overview, subsystem contract, API
reference, data model, UI/wireframe spec, runbook, or front-door index), and **Validate** an
existing doc against an 8-gate conformance checklist.

The five conformance rules in brief: (1) agents read the raw source; (2) source-complete, no
view-time JS; (3) content inline, CSS free; (4) faceted multi-axis `data-*` tags; (5) one
`data-source` + `data-verified` provenance primitive — plus *one shared toolkit + one construct
per doc type*.

---

## Install

Pick the path that fits your tool. **The skill lives at `skills/agentdocs/`** — that's the only
folder you ever copy.

### One command (any machine with bash + git)

```bash
curl -fsSL https://raw.githubusercontent.com/george4data/agentic_html_doc/main/install.sh | bash
```

Personal install → `~/.claude/skills/agentdocs`. Add `--project` (when running a local clone's
`./install.sh --project`) to install into the current repo's `./.claude/skills/` instead.

### Claude Code — as a managed plugin (gets `/plugin` updates)

```text
/plugin marketplace add george4data/agentic_html_doc
/plugin install agentdocs@agentic-html-doc
```

### Gemini CLI — as an extension

```bash
gemini extensions install https://github.com/george4data/agentic_html_doc
```

Loads [`GEMINI.md`](GEMINI.md), which routes the agent to the skill's operating manual.

### Manual copy (no installer, no plugin system)

```bash
git clone --depth 1 https://github.com/george4data/agentic_html_doc.git
cp -R agentic_html_doc/skills/agentdocs ~/.claude/skills/agentdocs
```

### claude.ai / Gemini app (web)

No GitHub auto-install in the web apps:
- **claude.ai:** upload the `skills/agentdocs/` folder in the Skills UI.
- **Gemini app:** create a Gem, paste the body of `SKILL.md` as instructions, attach the
  `reference/` and `templates/` files as knowledge.

---

## Asking an agent to install it

If you'd rather just tell Claude / Antigravity / another agent to do it, give it the exact path
so it doesn't have to explore:

> "Install the skill at `https://github.com/george4data/agentic_html_doc` — clone it and copy
> `skills/agentdocs/` into `~/.claude/skills/agentdocs/`. Or just run its `install.sh`."

---

## Verify the install

Ask the agent:

> "Use **agentdocs** to validate `templates/standard.html` against the Source-Complete Standard."

A correct install runs the validation workflow and returns an 8-gate table ending in
**CONFORMS** — the bundled exemplar is conformant by construction.

## How invocation works

`agentdocs` is **model-invoked**, not a slash command. Describe your task in natural language
("write agent-readable docs for the auth service", "validate these HTML docs") and the agent
loads the skill when it matches. To force it, name it: *"use the agentdocs skill to…"*.

## Repository layout

```
agentic_html_doc/
├── .claude-plugin/
│   ├── marketplace.json     ← Claude Code marketplace index (plugin source: ".")
│   └── plugin.json          ← Claude Code plugin manifest
├── gemini-extension.json    ← Gemini CLI extension manifest
├── GEMINI.md                ← Gemini context file
├── install.sh               ← one-command installer
├── README.md
├── LICENSE
└── skills/
    └── agentdocs/           ← the skill (this is the only folder you copy)
        ├── SKILL.md         ← operating manual (author + validate)
        ├── reference/       ← STANDARD.md, facet-ontology, constructs, checklist
        └── templates/standard.html  ← conforming exemplar
```

## License

[MIT](LICENSE) — free to use, modify, and redistribute.

## Status

Draft v0.1. The base facet vocabulary, a reference author-time (Pandoc) build, and a
docs-specific conformance benchmark are open items — see `STANDARD.md §10`.
