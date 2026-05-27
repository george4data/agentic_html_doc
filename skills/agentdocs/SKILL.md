---
name: agentdocs
description: >-
  Author and validate HTML-first, agent-readable documentation following The
  Source-Complete Standard. Use when creating or updating repository docs
  (architecture, subsystem contracts, API references, data models, UI/wireframe
  specs, runbooks, or the docs front-door index) that AI agents are meant to
  read, or when checking existing HTML docs for conformance. Triggers on intents
  like "write agent-readable docs", "document this for agents", "source-complete
  HTML docs", "validate these docs against the standard", "faceted data-* tags",
  "data-source/data-verified provenance", "CSS-only tabs", "front-door index".
license: MIT
---

# agentdocs

Author and validate documentation in **The Source-Complete Standard**: one static,
HTML-first file that serves AI agents first and humans second, with no view-time
JavaScript and no content duplication.

The full standard is bundled at [`reference/STANDARD.md`](reference/STANDARD.md). This
file is the operating manual; open the reference when you need exact rule text or the
governance model. **Read [`reference/STANDARD.md`](reference/STANDARD.md) once before
your first author or validate run in a session.**

## The five things that make a doc conform

Hold these in mind for every operation — they are the whole standard in miniature:

1. **Consumption contract** — agents read the *raw `.html` source*, never a
   browser-rendered snapshot. State this in the front-door index.
2. **Source-complete, no view-time runtime** — all content is inline in the source; **no
   `<script>` executes at view time**; nothing is fetched to reveal content. (Author-time
   build tools are fine — "no-runtime" ≠ "no-build".)
3. **Content inline, CSS free** — only styling may be inlined or linked; removing the CSS
   removes appearance, not content.
4. **Faceted multi-axis tags** — one un-duplicated region carries several orthogonal
   `data-*`/`class` facets at once (from a governed vocabulary), so it surfaces under many
   views with no copy and no cross-link.
5. **One provenance primitive** — `data-source` (the `path#Lx-Ly` a region shadows) +
   `data-verified` (date last checked) is the single trust mechanism for freshness,
   diagrams, and examples.

Plus the structural rule: **one shared toolkit + exactly one specialized construct per
doc type.**

---

## Workflow A — Author a conforming doc

Use when creating or updating a doc.

### A1. Pick the doc type and its one construct
Identify which type you are writing and the single specialized construct it requires
(full matrix in [`reference/doc-type-constructs.md`](reference/doc-type-constructs.md)):

| Doc type | Reader-job | Specialized construct |
|---|---|---|
| Front-door index | Locate | Typed links with triage payload (summary + axis tags + `data-job` + `data-cost`) |
| Architecture overview | Locate→Comprehend | Inline SVG with `<title>`/`<desc>` |
| Subsystem contract | Comprehend | `<details>` regions + provenance primitive |
| API reference | Comprehend→Act | Schema table (`data-field`, `data-type`, `data-calls`) |
| Data model | Comprehend | Schema table (`data-pk`, `data-fk`) + inline SVG ER |
| UI / wireframe spec | Act | Annotated skeletal form (`data-field`, `data-action`, `data-shows-when`) |
| Ops / runbook | Act | Ordered landmarks + `<details>` per step + `data-source` to scripts |
| Canonical example | Act | Static example pinned via `data-source` to a CI-tested file |

> Include the shared toolkit **plus exactly one** construct. Zero, or two, fails conformance.

### A2. Start from the template
Copy [`templates/standard.html`](templates/standard.html) and adapt it. It already
demonstrates: semantic landmarks, five faceted tags on one region, CSS-only `<details name>`
tabs, a schema table, an inline SVG with `<title>`/`<desc>`, a provenance-pinned example,
and an annotated skeletal form. Keep its `<head>` comment that tells agents how to read the file.

### A3. Apply the shared toolkit
- **Landmarks:** `<nav>`, `<main>`, `<section>`, `<article>`, real headings. One job per section.
- **Faceted tags:** add `data-*`/`class` from the governed vocabulary
  ([`reference/facet-ontology.md`](reference/facet-ontology.md)). Use existing facets; extend
  *values*, never invent new *facets* ad hoc. Tags go **inline on the element**, never in a
  JSON-LD `<script>` block.
- **Provenance:** put `data-source="path/to/file#Lx-Ly"` and `data-verified="YYYY-MM-DD"` on
  every trust-bearing region (anything that shadows code). Use *today's* date for
  `data-verified` only when you actually checked the region against the source.
- **Presentation:** for tabs/accordions use native `<details name="view">` + a `::details-content`
  rule. CSS only. The content stays in the source whether collapsed or open.

### A4. Diagrams
Pre-rendered **inline SVG** with authored `<title>` + `<desc>` and a `data-source`. Or ship
Mermaid **source text** in a `<pre>`. **Never** render Mermaid at view time.

### A5. Update the front door
Add or update the doc's entry in the front-door index (`index.html`): a one-line summary, its
axis tags, `data-job`, and a `data-cost` size hint. Ensure the index states the consumption
contract. If no index exists, create one (it is itself a doc type — see the matrix).

### A6. Self-check
Run **Workflow B** on what you just wrote before declaring it done.

---

## Workflow B — Validate a doc for conformance

Use when checking an existing `.html` doc (or one you just authored).

Run the checklist in [`reference/conformance-checklist.md`](reference/conformance-checklist.md)
against the file and report each item as PASS / FAIL / N-A with the offending line for any FAIL.
The hard gates:

- **G1 — Zero view-time JS.** No `<script>` elements; no inline `on*=` handlers; no `javascript:` URLs.
- **G2 — Source-complete.** No content reachable only via fetch/expand/click; collapsed
  `<details>` content is present in source.
- **G3 — Content inline.** Only CSS is externalized.
- **G4 — Faceted tags.** `data-*`/`class` facets are from the governed vocabulary; values
  controlled; carried inline (not JSON-LD).
- **G5 — Provenance.** Trust-bearing regions carry both `data-source` and `data-verified`.
- **G6 — One construct.** Shared toolkit present + exactly one specialized construct for the type.
- **G7 — Diagrams.** Inline SVG with `<title>`/`<desc>`, or shipped Mermaid source — never view-time rendered.
- **G8 — Front door (doc-set level).** A single index declares the consumption contract and lists docs with triage payloads.

Report format: a short table of gate → verdict → note, then a one-line overall verdict
(CONFORMS / DOES NOT CONFORM) and the top fixes.

---

## Known open items (v0.1)

Carry these as `TODO`; do not silently invent answers:

- **Base facet vocabulary** is not finalized — the facets in `reference/facet-ontology.md` are
  *candidates*. When a needed facet/value is missing, propose it and flag it, don't assume it.
- **Reference Pandoc writer / index schema** is unbuilt — if asked to set up an author-time
  build, scaffold it but mark it provisional.
- **No docs-specific conformance benchmark** exists — don't cite a success percentage as fact.

## Reference map

- [`reference/STANDARD.md`](reference/STANDARD.md) — the full standard (authoritative).
- [`reference/facet-ontology.md`](reference/facet-ontology.md) — facet governance + candidate vocabulary.
- [`reference/doc-type-constructs.md`](reference/doc-type-constructs.md) — toolkit + per-type construct matrix.
- [`reference/conformance-checklist.md`](reference/conformance-checklist.md) — the validation checklist.
- [`templates/standard.html`](templates/standard.html) — the conforming exemplar to copy.
