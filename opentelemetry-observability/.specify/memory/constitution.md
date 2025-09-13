# OpenTelemetry Observability — Project Constitution

This constitution defines non-negotiable principles, workflow rules, and quality gates for this repository. It aligns with the README, which remains the operator-facing source of truth.

## Core Principles

### I. Operator‑First, Doc‑Driven

- README is canonical for users: goals, toggles, steps, and diagrams must be accurate and current.
- Prefer simple, copy‑pasteable commands and minimal prerequisites.
- Any behavior change that affects operators requires a README update in the same PR.

### II. Helm Overlay, Not Fork

- Do not fork upstream charts unless strictly necessary; keep customizations in overlay values and small helper templates.
- Idempotent installs/updates via `helm upgrade --install` are mandatory.
- Keep changes minimal, reviewable, and focused on values/schema and tiny templates.

### III. Toggleable Backends (Single Choice per Category)

- Tracing: one of Tempo or Jaeger.
- Logging: one of Loki or OpenSearch.
- Metrics: Prometheus by default.
- All toggles live under `observability.*` in a single values file (e.g., `values/values.observability.yaml`).

### IV. Test‑First and CI Safety

- Red‑Green‑Refactor: write/update tests/linters first when changing behavior.
- Required validations in CI: `helm lint`, schema validation, `helm template` + kube schema (`kubeconform`/`kubectl --dry-run=server`), and at least one smoke install on Kind/minikube.
- Template logic must be covered by values profiles (e.g., Tempo+Loki, Jaeger+OpenSearch).

### V. Observability of the Observability Stack

- OTel Collector config must enable clear pipelines; internal telemetry should be available when feasible.
- Auto‑provision Grafana datasources and SLO dashboards when enabled.
- SLOs are defined with Sloth CRs; Prometheus and Alertmanager rules must be generated and visible.

### VI. Simplicity & Idempotence

- Prefer the simplest path that works for the demo; document alternatives briefly.
- Re‑runnable installs; do not require manual cluster edits beyond documented steps.
- Make targets/scripts should wrap complex commands for repeatability.

### VII. Versioning & Breaking Changes

- Use SemVer for the overlay and values schema.
- Breaking changes require: (1) README updates, (2) UPGRADING notes, (3) values.schema.json adjustments and validation, and (4) a migration example when possible.

## Additional Constraints & Standards

- Platform: Kubernetes ≥ 1.25, Helm ≥ 3.12.
- Security: No plaintext secrets in repo; RBAC follows least privilege; optional NetworkPolicies provided when relevant.
- Performance: This is a demo; include reasonable resource requests/limits and call out non‑production defaults.
- Diagrams: Keep Mermaid diagrams in README accurate; update alongside behavior changes.
- Values Schema: Ensure `values.schema.json` constrains toggles and prevents invalid combinations.

## Development Workflow, Reviews, and Quality Gates

### Workflow

- Feature branches with PRs; small and focused changes.
- Keep overlays and example profiles under `values/` (e.g., `values.observability.yaml`, `values/slo/*`).
- Prefer adding or updating example values profiles when introducing new toggles.

### Required Checks (Green‑Before‑Merge)

- Helm/chart: `helm lint`, dependency build/update (if vendored), and `helm template` with selected profiles.
- Schema: validate `values.schema.json` and example values against it.
- Kube validation: render then validate manifests via `kubeconform` or `kubectl --dry-run=server`.
- Integration smoke: Kind/minikube install for at least one stack (Tempo+Loki); ensure pods become Ready.
- Docs: README and diagrams updated; commands tested locally.

### Code Review Checklist

- Aligns with Core Principles and keeps upstream unmodified where possible.
- Toggle logic is clean, conditional, and validated by schema.
- Grafana provisioning and Sloth SLOs are gated by values and work out‑of‑the‑box.
- UPGRADING notes provided when behavior or schema changes.

## Governance

- This constitution supersedes other practices for this repo.
- Amendments require a PR with: rationale, impact analysis, updated README/diagrams, and a migration plan if relevant.
- Each PR must state compliance with this constitution or justify exceptions.
- README remains the single operator guide; drift is not allowed.

**Version**: 1.0.0 | **Ratified**: 2025-09-12 | **Last Amended**: 2025-09-12
