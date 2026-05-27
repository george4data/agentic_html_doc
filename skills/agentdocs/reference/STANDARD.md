# The Source-Complete Standard

**HTML-first, agent-readable documentation for software repositories.**

- **Version:** 0.1 (draft)
- **Status:** Draft for review — three items are explicitly open (see [§10](#10-open-items)).
- **Audience:** AI agents first, humans second.
- **Companion exemplar:** [`standard.html`](standard.html) — a conforming document that demonstrates every rule below on itself.

---

## 1. Why this exists

By 2026, roughly half of all documentation traffic comes from AI agents. Most docs are still written human-first, or split into a two-track "Markdown for bots, pretty HTML for humans" model that duplicates content and drifts out of sync.

This standard takes a different bet: **one un-duplicated, static HTML file can serve both readers at once.** The same bytes a human renders as a tabbed, navigable page are the bytes an agent parses for ground truth — because the structure that helps a human scan is the same structure a machine needs to chunk, locate, and trust.

The whole standard hangs on one idea you'll see repeated: **content lives in the source, fully present, always.** Everything else — tabs, styling, filtering — is decoration layered on top of content that is already there.

---

## 2. The Consumption Contract

> **Agents read the raw source file.**

This single sentence is the keystone. Declare it in your front-door index, and the rest of the standard becomes consistent. Here's why it matters.

An agent can perceive a web page three ways: a screenshot, the rendered accessibility tree, or the **raw HTML source**. These do *not* see the same thing. In particular:

> A collapsed `<details>` element is **removed from the accessibility tree.** Its content is hidden from anything reading the rendered page.

So if you build a doc with collapsible tabs and an agent reads it by *driving a browser*, the collapsed tabs vanish and the agent sees a fraction of your content. But if the agent reads the **raw `.html` file** — the way a coding agent, a RAG ingester, or a `fetch`-and-parse pipeline does — it sees 100% of the content regardless of what is collapsed, because CSS and collapse state never execute.

The contract tells every consumer which path to take. Under "agents read the raw source," collapsible multi-view becomes free: humans get tabs, agents get everything.

**Rule 2.1 — Declare the contract.** Every doc set states, in its front-door index and in any `llms.txt`-equivalent pointer, that agents are to consume the raw `.html` source, not a browser-rendered snapshot.

**Rule 2.2 — Never depend on the rendered path.** No content may be reachable *only* after a click, hover, expand, or script. If it isn't in the source, it doesn't exist.

---

## 3. Core rules

These three rules are non-negotiable. Everything in the toolkit obeys them.

**Rule 3.1 — Source-complete, no view-time runtime.** The delivered file is static and complete. **No JavaScript executes at view/consumption time.** An agent parsing the raw HTML must obtain every piece of content without running code or fetching anything.

**Rule 3.2 — Content is inline; only styling may be external.** All *content* lives inline in the source. *CSS* may be inlined in a `<style>` block (for single-file portability) or linked (for a doc set) — either is fine, because removing the CSS removes zero content. An agent ignores styling entirely.

**Rule 3.3 — Declare trust, don't enforce it.** The standard itself declares freshness and provenance as metadata an agent reasons about (see [§4.3](#43-the-provenance-primitive)). It does **not** require a CI gate or build step to function. Enforcement is an optional, external layer.

> **"No-runtime" ≠ "no-build."** Rule 3.1 forbids JavaScript at *view* time. It does **not** forbid an *author-time* build (e.g. a Markdown-to-HTML pipeline). Generate the HTML however you like; just ship a static, complete file. See [§8](#8-authoring-and-build).

---

## 4. The shared toolkit

Every conforming document — whatever its type — is built from the same four ingredients. Learn these once and you can read or write any doc in the system.

### 4.1 Semantic landmarks

Use real HTML5 landmarks and headings — `<nav>`, `<main>`, `<section>`, `<article>`, `<h1>`–`<h6>` — never `<div>` soup.

Landmarks do triple duty:
1. **Humans** scan them.
2. **Agents** get correct roles in the accessibility tree automatically.
3. **Retrieval systems** use them as chunk boundaries — structure-aware chunking is the highest-precision, lowest-cost way to split HTML for RAG, and it needs no LLM compute.

A `<section>` is a retrieval unit. Name it with a heading; give it one job.

```html
<section data-layer="backend" data-service="auth">
  <h2>Token issuance</h2>
  ...
</section>
```

### 4.2 Faceted multi-axis tags

This is *why HTML*, not Markdown. A single content region carries several **orthogonal classifications at once**, via inline `data-*` attributes and `class`. The same un-duplicated `<section>` can surface under a "Frontend" view, a "Security" view, and a "v2 API" filter — with no copy, no cross-link, nothing to rot.

```html
<section class="frontend security"
         data-epic="login"
         data-api-version="2"
         data-diataxis="reference">
  ...
</section>
```

This is **faceted classification** — a mature library-science discipline. Two governance rules keep it from sprawling (full model in [`facet-ontology.md`](_bmad-output/specs/spec-html-first-agent-docs-standard/facet-ontology.md)):

**Rule 4.2.1 — Facets are governed; values are extensible.** A small base set of facets is fixed by the standard. A repo may add new *values* within a facet (`data-service="search"`), but must not invent new *facets* ad hoc. Adding a facet is a standard-level decision.

**Rule 4.2.2 — Controlled values; inline carrier.** Each facet draws from a controlled vocabulary (no `frontend`/`front-end`/`fe` for the same thing). Tags are always inline `data-*`/`class` — never a decoupled JSON-LD `<script>` block, because the tag must ride with the content it describes.

> The base facet vocabulary is **not yet finalized** — see [§10](#10-open-items).

### 4.3 The provenance primitive

One mechanism handles trust, diagrams, and examples. Just two attributes:

| Attribute | Meaning |
|---|---|
| `data-source` | The code this region shadows — `path/to/file.ts#L40-L78`. |
| `data-verified` | The date this region was last checked against that source — `2026-05-26`. |

```html
<section data-source="src/auth/token.ts#L40-L78" data-verified="2026-05-26">
  <h2>Token issuance</h2>
  <p>Tokens are signed with RS256 and expire after 15 minutes.</p>
</section>
```

An agent reads this and *reasons*: "last verified 3 days ago, against `token.ts` — trustworthy enough for a summary; for an exact value, I'll follow `data-source` to ground truth." Trust becomes informed judgment, not a pipeline promise.

**Rule 4.3.1 — One primitive, three jobs.** The same `data-source` + `data-verified` pair is the trust mechanism for freshness, for diagrams (link to the diagram source), and for canonical examples (link to a tested example). Do not invent separate mechanisms.

### 4.4 CSS-only presentation

Humans want tabs and accordions. You can give them that with **zero JavaScript** using native `<details name>` exclusive groups plus the `::details-content` pseudo-element (Baseline 2025).

```html
<!-- Tabs: only one open at a time, no JS. All content present in source. -->
<details name="view" open>
  <summary>Frontend</summary>
  <section data-layer="frontend">...</section>
</details>
<details name="view">
  <summary>Backend</summary>
  <section data-layer="backend">...</section>
</details>
```

**Rule 4.4.1 — Presentation over fully-present content only.** A `<details>` may *hide* content visually, but the content is in the source either way. Under the consumption contract ([§2](#2-the-consumption-contract)), the agent reads it regardless of collapse state. Never use `<details>` (or any CSS/JS) as a gate that *withholds* content from the source.

---

## 5. The front-door index

Every doc set opens with a single HTML entry-point — the agent's front door — so it never reads 400 files to find 2. It maps the territory and links to every other doc.

Each entry carries a **triage payload** so an agent can decide what to open *before* spending tokens on it:

| Part | Purpose | Carrier |
|---|---|---|
| One-line summary | What's inside | link text / `title` |
| Axis tags | Which facets this doc covers | `data-*` on the link |
| Reader-job | Locate / Comprehend / Act | `data-job` |
| Token-cost hint | Roughly how big | `data-cost` |

```html
<nav>
  <h1>Documentation index</h1>
  <p>Agents: read the raw <code>.html</code> source of each linked file.</p>
  <ul>
    <li><a href="auth.html"
           data-service="auth" data-job="comprehend" data-cost="2k">
        Auth subsystem — token issuance, sessions, RS256 signing</a></li>
    <li><a href="login-ui.html"
           data-epic="login" data-job="act" data-cost="1k">
        Login screen — fields, validation, the action it calls</a></li>
  </ul>
</nav>
```

The size hint is nonsense to a human and essential to an agent: it makes a large repo navigable on a token budget.

**Rule 5.1 — Single front door.** A doc set has exactly one front-door index; it declares the consumption contract and lists every doc with its triage payload.

---

## 6. Doc types and specialized constructs

The toolkit is the same everywhere. What changes per doc type is **one specialized construct.**

> **Rule 6.1 — Toolkit + exactly one construct.** A conforming doc presents the full shared toolkit ([§4](#4-the-shared-toolkit)) **plus exactly one** specialized construct for its declared type. Zero constructs, or two, fails conformance.

| Doc type | Reader-job | Specialized construct |
|---|---|---|
| Front-door index | Locate | Typed links with triage payload ([§5](#5-the-front-door-index)) |
| Architecture overview | Locate → Comprehend | Inline SVG with `<title>`/`<desc>` |
| Subsystem contract | Comprehend | `<details>` regions + provenance primitive |
| API reference | Comprehend → Act | Schema table (`data-field`, `data-type`, `data-calls`) |
| Data model | Comprehend | Schema table (`data-pk`, `data-fk`) + inline SVG ER |
| UI / wireframe spec | Act | Annotated skeletal form (`data-field`, `data-action`, `data-shows-when`) |
| Ops / runbook | Act | Ordered landmarks + `<details>` per step + `data-source` to scripts |
| Canonical example | Act | Static example pinned via `data-source` to a CI-tested file |

The full matrix, including which facets each type typically carries, lives in [`doc-type-constructs.md`](_bmad-output/specs/spec-html-first-agent-docs-standard/doc-type-constructs.md).

### Two constructs worth a closer look

**Schema table** — for APIs and data models, the table *is* the contract. Tag the cells so an agent reads the shape, not just the prose:

```html
<table>
  <tr><th>Field</th><th>Type</th><th>Notes</th></tr>
  <tr data-field="email" data-type="string"><td>email</td><td>string</td><td>RFC 5322</td></tr>
  <tr data-field="ttl" data-type="int"><td>ttl</td><td>int</td><td>seconds, default 900</td></tr>
</table>
```

**Annotated skeletal form** — a wireframe and a build-spec collapsed into one artifact. It's real semantic HTML, deliberately unstyled, annotated with intent. A human renders it for a rough visual; an agent reads it as an exact build contract — no screenshot, no pixel-reading.

```html
<form data-screen="login">
  <label>Email
    <input data-field="email" type="email"
           data-validation="required, rfc5322">
  </label>
  <button data-action="POST /auth/login"
          data-shows-when="email valid">Sign in</button>
</form>
```

---

## 7. Diagrams

**Rule 7.1 — A diagram's meaning comes from authored text, never from pixels or geometry.**

Use **pre-rendered inline SVG** with an authored `<title>` and `<desc>`, plus a `data-source` to the diagram's source:

```html
<svg viewBox="0 0 200 80" role="img"
     aria-labelledby="d1-t d1-d" data-source="docs/diagrams/auth-flow.mmd">
  <title id="d1-t">Auth token flow</title>
  <desc id="d1-d">Client posts credentials to /auth/login; server returns a 15-minute RS256 JWT; client sends it as a Bearer token.</desc>
  ...
</svg>
```

Mermaid is acceptable **only** as shipped *source text* inside the HTML (e.g. in a `<pre>` inside `<details>`) — never rendered at view time. Client-rendered Mermaid is forbidden: it needs a JS runtime (breaking Rule 3.1) and its rendered output is near-nonsense to an agent anyway.

---

## 8. Authoring and build

The biggest worry about a hand-authored-HTML standard — *"who writes all this verbose markup?"* — mostly dissolves in an agent-first world: increasingly the author is an agent (or an agent-assisted human), and verbose, consistent, tagged markup is exactly what agents emit tirelessly.

You do not have to abandon your current toolchain. Treat the standard as an **HTML output target:**

- Author in Markdown / a tagged source where your team already lives.
- Run an **author-time build** (e.g. a Pandoc custom writer) that injects semantic landmarks, faceted tags, and provenance scaffolding, then emits a static, source-complete `.html`. This is permitted by Rule 3.1 — the build runs at author time, not view time.
- Hand-author only the high-value hub docs (the front-door index, the architecture overview).

> The **reference Pandoc writer** and front-door index schema are **not yet built** — see [§10](#10-open-items).

---

## 9. Conformance

A document conforms to v0.1 when:

1. It is a static `.html` file that needs **no view-time JavaScript** and **no network fetch** to yield all its content. (Rule 3.1)
2. All content is inline; only CSS is externalized. (Rule 3.2)
3. It uses semantic landmarks, faceted `data-*`/`class` tags from the governed vocabulary, and the `data-source`/`data-verified` provenance primitive on trust-bearing regions. (§4)
4. Any multi-view is CSS-only and presentation-over-present-content. (Rule 4.4.1)
5. It presents the shared toolkit **plus exactly one** specialized construct for its type. (Rule 6.1)
6. Diagrams are inline SVG (or shipped Mermaid source), never view-time rendered. (Rule 7.1)

A doc set additionally has one front-door index that declares the consumption contract. (§5, §2)

---

## 10. Open items

Three things are deliberately unresolved in v0.1. Treat them as `TODO`, not as settled.

- **`TODO` — Base facet vocabulary.** The candidate facets (`layer`, `service`, `domain`, `diataxis`, `epic`, `api-version`, `security`/`pii`, `severity`) and their controlled values are *candidates only*. A dedicated information-architecture pass must finalize the set and the permitted values before v1.0. (See [`facet-ontology.md`](_bmad-output/specs/spec-html-first-agent-docs-standard/facet-ontology.md).)

- **`TODO` — Reference Pandoc writer + front-door index schema.** The author-time build path ([§8](#8-authoring-and-build)) is specified in principle but not implemented. A reference writer and a machine-checkable index schema are needed as the adoption on-ramp.

- **`TODO` — Docs-specific conformance/effectiveness benchmark.** There is no measured benchmark for agent success against docs in *this* format. The best-sourced figure in the literature (~78% agent task success on accessible pages) is for general web tasks, not documentation. Do not assume a number; build the benchmark.

---

*This standard is the human-readable contract. For the machine contract it was distilled from, see the spec at `_bmad-output/specs/spec-html-first-agent-docs-standard/`.*
