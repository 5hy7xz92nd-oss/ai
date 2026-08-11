# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) where release tags are used.

The package is currently in **alpha**; APIs may change between releases.

## [Unreleased]

### Added

- Architecture documentation (`docs/ARCHITECTURE.md`) with a component dependency graph derived from `Package.swift`
- Documentation index (`docs/README.md`)
- Contributing guide (`CONTRIBUTING.md`) and GitHub pull request template
- This changelog
- README sections for architecture overview, dependencies, protocol capability matrix, documentation links, and an updated module roadmap

### Changed

- README table of contents expanded to include Architecture, Dependencies, Documentation, Contributing, and Changelog
- Clarified **AI product vs AI module** re-exports (`import AI` exports CoreMI, LargeLanguageModels, OpenAI only)
- Documented SPM product list exactly as in `Package.swift` and noted targets without standalone products
- Documented test-target gaps (Ollama, Rime, TogetherAI registration, CoreMI)
- Fixed stray `</div>` markup and platform notes (including visionOS) in the README

## [0.0.1] - 2024-01-01

Baseline snapshot of the public **alpha** tree (date is a documentation anchor, not a git tag guarantee):

- Core layers: `CoreMI`, `LargeLanguageModels`
- Umbrella product `AI` and standalone provider libraries
- Provider integrations including OpenAI, Anthropic, Mistral, Groq, Ollama, Hugging Face hub helpers, embeddings providers (Cohere, Jina, VoyageAI, TogetherAI), voice providers (ElevenLabs, PlayHT, Rime, HumeAI, NeetsAI), Perplexity, and experimental `_Gemini`
- Shared abstractions: `LLMRequestHandling`, `PromptLiteral`, `AbstractLLM` chat/function-calling types, text embeddings protocols
- MIT license

<!--
When cutting a release:
1. Move items from [Unreleased] into a new version section with the date (YYYY-MM-DD).
2. Tag the repository to match.
3. Link version headers to GitHub compare URLs if desired.
-->
