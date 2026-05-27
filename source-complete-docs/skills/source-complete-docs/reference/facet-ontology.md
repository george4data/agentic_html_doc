# Facet Ontology (governance model + candidate base set)

Companion to [SPEC.md](SPEC.md). Defines how the multi-axis classification (CAP-2) is governed. The standard's keystone is **faceted classification**: one un-duplicated content region tagged along several orthogonal facets at once, each facet an independent axis a reader can filter on.

## Governance rules (load-bearing — v0.1)

1. **Facets are governed; values may be extended.** A small base facet-set is fixed by the standard. A repo MAY add new *values* within an existing facet, but MUST NOT invent new *facets* ad hoc. Adding a facet is a standard-level change, not a per-doc one.
2. **Controlled values.** Each facet draws from a controlled vocabulary to prevent the ambiguity faceted classification exists to remove (e.g. not `frontend`/`front-end`/`fe` for the same value).
3. **Inline carrier.** Facets are expressed as inline `data-*` / `class` on the content region, never as a decoupled JSON-LD `<script>` block — the tag rides with what it describes.
4. **Orthogonality.** Facets are independent axes; a region carries at most one value per facet unless the facet is explicitly declared multi-valued.

## Candidate base facet-set **[TODO — requires an IA pass before lock]**

These are *candidates* carried from the research, not yet ratified. The IA pass (Open Question in SPEC.md) finalizes the set and the controlled values.

| Facet | Axis it expresses | Candidate carrier | Example values |
|---|---|---|---|
| `layer` | Architectural layer | `class` / `data-layer` | frontend, backend, infra |
| `service` | Owning service/component | `data-service` | auth, billing, search |
| `domain` | Business/problem domain | `data-domain` | identity, payments |
| `diataxis` | Diátaxis content purpose (orthogonal to reader-job) | `data-diataxis` | tutorial, how-to, reference, explanation |
| `epic` | Delivery grouping | `data-epic` | login, checkout |
| `api-version` | API/version filter | `data-api-version` | 1, 2 |
| `security` / `pii` | Sensitivity | `data-security`, `data-pii` | public, internal; true/false |
| `severity` | Ops/runbook severity | `data-severity` | sev1, sev2 |

Note: `diataxis` is a facet, **not** a replacement for the Locate/Comprehend/Act reader-job model — the two are orthogonal. Reader-job is a property of a doc region's purpose for the reader; Diátaxis type is a property of the content's pedagogical kind.
