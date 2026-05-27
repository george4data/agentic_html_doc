# Conformance Checklist — The Source-Complete Standard v0.1

Run this against a single `.html` doc. Mark each gate **PASS / FAIL / N-A**; for any FAIL,
quote the offending line. Doc-set gates (G8) apply to the front-door index, not every file.

## Hard gates (a FAIL here means the doc does not conform)

### G1 — Zero view-time JavaScript
- [ ] No `<script>` elements anywhere in the file.
- [ ] No inline event handlers (`onclick`, `onload`, `on*=`).
- [ ] No `javascript:` URLs.
- [ ] No `<style>` that depends on script-toggled state to reveal content.
- *How to check:* `grep -i '<script\|on[a-z]*=\|javascript:' file.html` should return nothing meaningful.

### G2 — Source-complete
- [ ] All content is present in the raw source; nothing is fetched at view time to reveal it.
- [ ] Collapsed `<details>` / inactive tabs contain their full content in the source.
- [ ] No element is an empty shell awaiting client rendering.

### G3 — Content inline, CSS free
- [ ] Every piece of *content* is inline in the HTML.
- [ ] Only *styling* is externalized (inline `<style>` or linked stylesheet) — removing CSS
      removes appearance, not content.

### G4 — Faceted multi-axis tags
- [ ] Classification is carried by inline `data-*` / `class` on the content element.
- [ ] No load-bearing classification hidden in a decoupled JSON-LD `<script>` block.
- [ ] Facets used are from the governed set; values are from the controlled vocabulary
      (no synonyms like `frontend` vs `fe`). See `facet-ontology.md`.
- [ ] No ad-hoc *new facet* invented at the doc level (new *values* are allowed).

### G5 — Provenance primitive
- [ ] Every trust-bearing region (anything that shadows code) carries `data-source`
      (`path#Lx-Ly`) **and** `data-verified` (`YYYY-MM-DD`).
- [ ] Canonical examples are pinned via `data-source` to a tested file (not free-floating).
- [ ] No alternative/duplicate trust mechanism is used instead of this primitive.

### G6 — One specialized construct
- [ ] The shared toolkit is present: semantic landmarks + faceted tags + provenance + (if
      multi-view) CSS-only `<details name>`.
- [ ] **Exactly one** specialized construct for the doc's declared type is present
      (see `doc-type-constructs.md`). Zero, or two, is a FAIL.

### G7 — Diagrams
- [ ] Diagrams are inline `<svg>` with authored `<title>` and `<desc>`, or shipped Mermaid
      **source text** in a `<pre>`.
- [ ] No diagram is rendered from text at view time (no client-side Mermaid/script).

## Doc-set gate (front-door index only)

### G8 — Front door
- [ ] Exactly one front-door index exists for the doc set.
- [ ] It explicitly states the consumption contract ("agents read the raw `.html` source").
- [ ] Each listed doc carries a triage payload: one-line summary, axis tags, `data-job`
      (locate/comprehend/act), and a `data-cost` size hint.

## Soft checks (warn, don't fail)

- [ ] `data-verified` dates are recent relative to the `data-source` target's last change.
- [ ] Sections have a single clear job (good RAG chunk boundaries).
- [ ] `<summary>` labels read as meaningful tab/section names.

## Output template

```
Gate  Verdict  Note
G1    PASS     —
G2    FAIL     line 88: content loaded via fetch() in a <script>
...
Overall: DOES NOT CONFORM
Top fixes: (1) remove the <script> at line 88 and inline the content; (2) add data-verified to <section id="auth">.
```
