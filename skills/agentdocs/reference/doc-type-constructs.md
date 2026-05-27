# Doc-Type Constructs (the shared toolkit + one specialized construct per type)

Companion to [SPEC.md](SPEC.md). Defines CAP-8: every doc type uses the **same shared toolkit** plus **exactly one specialized construct**.

## The shared toolkit (every doc type uses all of it)

- **Semantic landmarks** (`<nav>`, `<main>`, `<section>`, `<article>`, headings) — chunk boundaries that double as accessibility-tree roles and RAG retrieval units. (Locate / Comprehend)
- **Faceted multi-axis tags** — inline `data-*` / `class` per [facet-ontology.md](facet-ontology.md). (filtering / CAP-2)
- **Provenance primitive** — `data-source` + `data-verified` on trust-bearing regions. (CAP-5)
- **CSS-only presentation** — `<details name>` exclusive groups + `::details-content` for tabs/accordions over fully-present source. (CAP-4)

## One specialized construct per doc type

| Doc type | Primary reader-job | Specialized construct | Multi-axis tags typically carried |
|---|---|---|---|
| Front-door index | Locate | Typed links with per-entry triage payload: one-line summary + axis tags + reader-job + token-cost hint | the repo's whole axis vocabulary |
| Architecture overview | Locate → Comprehend | Inline SVG (with `<title>`/`<desc>`) | `layer`, `service`, `domain` |
| Subsystem contract | Comprehend | `<details>` regions + provenance primitive | `layer`, `epic`, `security` |
| API reference | Comprehend → Act | Schema table (`data-field`/`data-type`, `data-calls`) | `api-version`, `auth`, `resource` |
| Data model | Comprehend | Schema table (`data-pk`/`data-fk`) + inline SVG ER | `domain`, `service`, `pii` |
| UI / wireframe spec | Act | Annotated skeletal form (`data-field`/`data-action`/`data-shows-when`) | `screen`, `epic`, frontend `layer` |
| Ops / runbook | Act | Ordered landmarks + `<details>` per step + `data-source` to scripts | `service`, `severity`, `oncall` |
| Canonical example (Act, any type) | Act | Static example pinned via `data-source` to a CI-tested file (CAP-6) | inherits host doc's tags |

**Validation rule (CAP-8):** a conforming doc presents the full shared toolkit and exactly one specialized construct for its declared type. Zero constructs, or two, fails.

## Diagram rule

Diagrams use **pre-rendered inline SVG with authored `<title>`/`<desc>`**, or ship the Mermaid **source text** inside the HTML (e.g. in `<details>`/`<pre>`). Never view-time JS rendering — Mermaid's rendered output is poorly machine-readable, and rendering requires a runtime that breaks source-completeness. (CAP-7)
