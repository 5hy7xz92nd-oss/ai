# Documentation

Guides for the **AI** Swift package ([PreternaturalAI/AI](https://github.com/PreternaturalAI/AI)).

| Document | Audience | Description |
|----------|----------|-------------|
| [../README.md](../README.md) | Everyone | Install, usage examples, architecture summary, dependency graph, roadmap |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Contributors & integrators | Layers, products vs targets, Mermaid graphs, protocol matrix, tests |
| [../CONTRIBUTING.md](../CONTRIBUTING.md) | Contributors | Setup, PR process, adding providers |
| [../CHANGELOG.md](../CHANGELOG.md) | Everyone | Notable changes |
| [../LICENSE](../LICENSE) | Everyone | MIT |

## Quick orientation

```text
Package.swift          products, targets, external deps
Sources/CoreMI         foundations (requests, model IDs, services)
Sources/LargeLanguageModels   AbstractLLM, prompts, embeddings protocols
Sources/<Provider>     vendor clients
Sources/AI             umbrella module (selective @_exported imports)
Tests/                 parallel test targets (see ARCHITECTURE.md for gaps)
docs/                  long-form documentation (this folder)
```

## Repository research plan

1. Baseline architecture from `Package.swift` and `docs/ARCHITECTURE.md` (targets, product boundaries, and layer rules).
2. Validate provider consistency by sampling one provider per modality (chat, embeddings, speech) and comparing request handling patterns.
3. Audit test coverage by target under `Tests/` and identify missing behavior checks for provider-specific features.
4. Review integration risk points: shared protocol changes in `LargeLanguageModels`, dependency changes in `CoreMI`, and provider-to-provider coupling.
5. Prioritize a short backlog: architecture parity tasks, test gaps, and docs updates tied to each accepted change.

## Agent/workflow roles

- **Scope agent**: confirms target module(s), expected behavior, and acceptance criteria before edits.
- **Architecture agent**: enforces layering (`providers → LargeLanguageModels → CoreMI`) and checks product/target dependency impact.
- **Implementation agent**: makes focused changes in one area, following existing patterns and minimizing cross-target churn.
- **Validation agent**: runs required verification (`swift test` when behavior changes) and checks for regressions/security/secrets.
- **Release agent**: updates `README.md`, `docs/ARCHITECTURE.md`, and `CHANGELOG.md` when public behavior or package structure changes.

Recommended workflow sequence:

1. Scope agent drafts change intent and acceptance criteria.
2. Architecture agent approves dependency/layer impact.
3. Implementation agent applies a minimal, focused patch.
4. Validation agent verifies behavior and safety.
5. Release agent finalizes documentation/changelog completeness.

## Keeping docs honest

When you change `Package.swift` or add a provider:

1. Update the dependency graph and tables in [ARCHITECTURE.md](ARCHITECTURE.md).
2. Mirror user-facing bits in [../README.md](../README.md) (products, roadmap, import notes).
3. Note the change under `[Unreleased]` in [../CHANGELOG.md](../CHANGELOG.md).
