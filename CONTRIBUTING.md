# Contributing

Thanks for your interest in improving **AI** — the open-source Swift framework for generative AI ([PreternaturalAI/AI](https://github.com/PreternaturalAI/AI)).

This guide covers how to set up the package, make changes that match existing patterns, and submit contributions.

## Code of conduct

Be respectful and constructive in issues, discussions, and pull requests. Harassment or bad-faith behavior is not acceptable.

## Getting started

### Requirements

- macOS with a recent **Xcode** (CI builds with Xcode **16.2** and **16.3**; see [`.github/workflows/preternatural-build.yml`](.github/workflows/preternatural-build.yml))
- Swift **5.10+** (`// swift-tools-version:5.10` in `Package.swift`)
- Network access to resolve package dependencies (Swallow, Merge, NetworkKit, CorePersistence, SwiftUIX)

### Clone and open

```bash
git clone https://github.com/PreternaturalAI/AI.git
cd AI
open Package.swift
```

Or resolve and build from the command line:

```bash
swift package resolve
swift build
```

### Run tests

```bash
swift test
```

Many integration-style tests expect provider API keys. Prefer unit tests that do not call live APIs when possible. Do not commit secrets; use environment variables or local config that stays out of git (see `.gitignore`).

## Project layout

```
Sources/
  CoreMI/                 # Core request, model ID, service, ASR/TTS foundations
  LargeLanguageModels/    # AbstractLLM, prompts, embeddings protocols
  OpenAI/, Anthropic/, …  # Provider clients
  AI/                     # Umbrella re-exports
Tests/                    # Parallel test targets per area
docs/                     # Architecture and long-form docs
Package.swift             # Products, targets, external dependencies
```

Read [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the dependency graph and layering rules before large changes.

## How to contribute

### Bug reports

Open an issue with:

- What you expected vs what happened
- Package version / commit and Xcode version
- Provider and model (if relevant)
- Minimal reproduction (code snippet preferred)

### Feature requests

Describe the use case and whether it fits an existing protocol (`LLMRequestHandling`, `TextEmbeddingsRequestHandling`, TTS types, etc.) or needs a new abstraction.

### Pull requests

1. Fork the repository and create a branch from `main`.
2. Keep changes focused; prefer small PRs.
3. Match existing naming and file layout (`Sources/<Module>/Intramodular/…`).
4. Update docs when you change public API, products, or dependencies:
   - [README.md](README.md) for user-facing behavior
   - [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) if targets or the graph change
   - [CHANGELOG.md](CHANGELOG.md) under an “Unreleased” section
5. Add or extend tests under `Tests/` when practical.
6. Ensure the project builds for your change set.
7. Fill in a clear PR description (motivation, approach, test plan).

## Adding or extending a provider

Typical pattern for a new remote API client:

1. **Target** — Add a `.target` (and optionally a `.library` product) in `Package.swift` with dependencies on `LargeLanguageModels`, `NetworkKit`, `Merge`, `Swallow`, and usually `CoreMI` / `CorePersistence`.
2. **Module root** — `Sources/<Provider>/module.swift` and namespace enum (see existing providers).
3. **API specification** — NetworkKit-oriented `APISpecification` + request/response body types.
4. **Client** — `<Provider>.Client` holding credentials and performing requests.
5. **Protocol conformance** — e.g. `LLMRequestHandling` or `TextEmbeddingsRequestHandling` in an extension file.
6. **Models** — Strongly typed model identifiers conforming to `ModelIdentifierConvertible` where applicable.
7. **Umbrella** — Only add to the `AI` product/target if the provider should ship with the default umbrella import.
8. **Tests** — `Tests/<Provider>/` test target depending on `AI` or the standalone product.
9. **Docs** — Architecture table, README usage/roadmap, and CHANGELOG.

Prefer implementing shared protocols over one-off APIs so apps can swap providers.

### Dependency rules

- Do **not** introduce provider → provider dependencies unless there is a strong shared-type reason (today only **Perplexity → OpenAI**).
- New external packages require a clear rationale and a `Package.swift` + `Package.resolved` update.
- Keep the layering: providers → `LargeLanguageModels` → `CoreMI` → external foundation packages.

## Coding guidelines

- **Swift concurrency** — Prefer `async`/`await`; align with `Merge` / existing client patterns.
- **Access control** — Many targets use `AccessLevelOnImport`; follow neighboring files.
- **Errors** — Surface typed errors where the module already does; avoid swallowing failures silently.
- **Formatting** — Match the style of the file you edit (indentation, import order, documentation comments).
- **Copyright** — New source files typically include the existing file header style used in the module.

## Documentation

| Doc | Purpose |
|-----|---------|
| [README.md](README.md) | Install, usage examples, links |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Layers, products, dependency graph |
| [CHANGELOG.md](CHANGELOG.md) | User-visible changes |
| [LICENSE](LICENSE) | MIT |

When editing architecture docs, regenerate or manually update the Mermaid graph so it stays consistent with `Package.swift`.

## CI

Pushes and PRs to `main` run the **Build** workflow (Preternatural build action on macOS runners). Fix build failures before merge.

## License

By contributing, you agree that your contributions are licensed under the same **MIT** license as the project ([LICENSE](LICENSE)).

## Questions

- Open a GitHub Discussion or Issue on [PreternaturalAI/AI](https://github.com/PreternaturalAI/AI)
- For architecture questions, start from [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
