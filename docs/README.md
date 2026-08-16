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

## Keeping docs honest

When you change `Package.swift` or add a provider:

1. Update the dependency graph and tables in [ARCHITECTURE.md](ARCHITECTURE.md).
2. Mirror user-facing bits in [../README.md](../README.md) (products, roadmap, import notes).
3. Note the change under `[Unreleased]` in [../CHANGELOG.md](../CHANGELOG.md).
