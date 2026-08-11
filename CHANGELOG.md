# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) where release tags are used.

The package is currently in **alpha**; APIs may change between releases.

## [Unreleased]

### Added

- Architecture documentation (`docs/ARCHITECTURE.md`) with a component dependency graph derived from `Package.swift`
- Contributing guide (`CONTRIBUTING.md`)
- This changelog
- README sections for architecture overview, dependencies, documentation links, and an updated module roadmap

### Changed

- README table of contents expanded to include Architecture, Dependencies, Documentation, Contributing, and Changelog

## [0.0.1] - Alpha

Initial public alpha of the **AI** Swift package (Preternatural AI):

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
