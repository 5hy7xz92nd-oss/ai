# Contributing

Thanks for contributing to AI.

## Prerequisites

- Xcode 15.4+ (Swift 5.10 toolchain)
- Apple platform SDKs supported by this package

## Getting Started

1. Fork the repository and create a feature branch.
2. Make focused changes with clear commit messages.
3. Run tests locally:

```bash
swift test
```

4. Update documentation when behavior, APIs, or architecture changes.
5. Open a pull request with a clear summary and test notes.

## Pull Request Checklist

- [ ] Changes are scoped to one topic
- [ ] Public API changes are documented
- [ ] Tests pass locally (`swift test`)
- [ ] README/docs/changelog updated when needed

## Repository Research Plan

When working in this repository, start by identifying the layer and capability you are changing before touching code.

1. Map the affected API surface:
   - `Sources/CoreMI`
   - `Sources/LargeLanguageModels`
   - `Sources/AI`
   - the specific provider target under `Sources/`
2. Inventory shared abstractions and extension points involved in the change:
   - request handling
   - model identifiers
   - chat/completions
   - embeddings
   - audio, file, structured output, and tool-calling support
3. Compare provider parity for that capability to avoid introducing one-off patterns.
4. Audit the relevant tests under `Tests/` by capability as well as by provider.
5. Update docs when package products, imports, architecture, or behavior change.
6. Run `swift test` for code changes and record any notable validation steps in the pull request.

## Agent / Workflow Roles

Use focused ownership when splitting work across contributors or automation:

- **Architecture**: owns module boundaries, `Package.swift`, and `docs/ARCHITECTURE.md`.
- **Core abstractions**: owns `CoreMI` and `LargeLanguageModels` protocols, shared request/response behavior, and compatibility across providers.
- **Provider**: owns one provider target at a time and aligns provider-specific APIs with shared abstractions.
- **Test**: expands coverage in `Tests/`, adds reusable fixtures/helpers, and verifies `swift test`.
- **Docs**: keeps `README.md`, `CONTRIBUTING.md`, `docs/ARCHITECTURE.md`, and `CHANGELOG.md` aligned with code changes.
- **Release / governance**: checks change scope, public API impact, dependency layering, and pull request hygiene.

Recommended workflow:

1. Scope work to one layer or one provider.
2. Review architecture or shared abstraction impact first.
3. Implement the provider or core change.
4. Update tests for behavior changes.
5. Update docs for API, product, or architecture changes.
6. Run `swift test`.
7. Review for consistency with neighboring providers before merging.

## Reporting Issues

When filing a bug, include:

- Steps to reproduce
- Expected vs actual behavior
- Platform and Xcode/Swift versions
- Relevant logs or sample payloads
