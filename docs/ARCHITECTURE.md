# Architecture

This document describes the structure of the **AI** Swift package as defined by [`Package.swift`](../Package.swift) and the modules under [`Sources/`](../Sources).

## Overview

The package is a layered Swift framework for generative AI on Apple platforms. Higher layers depend only on lower layers; provider SDKs plug into shared protocols rather than into each other (with one documented exception: **Perplexity** depends on **OpenAI** for shared types).

```
┌─────────────────────────────────────────────────────────────┐
│  Products (importable libraries)                            │
│  AI (umbrella) · OpenAI · Anthropic · … · _Gemini · …       │
└─────────────────────────────┬───────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────┐
│  Provider targets                                           │
│  OpenAI, Anthropic, Mistral, Groq, Ollama, …                │
│  Implement LLMRequestHandling / embeddings / TTS / etc.     │
└─────────────────────────────┬───────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────┐
│  LargeLanguageModels                                        │
│  AbstractLLM, PromptLiteral, embeddings protocols           │
└─────────────────────────────┬───────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────┐
│  CoreMI                                                     │
│  Request handling, model IDs, services, ASR/TTS foundations │
└─────────────────────────────┬───────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────┐
│  External packages                                          │
│  Swallow · Merge · NetworkKit · CorePersistence · SwiftUIX  │
└─────────────────────────────────────────────────────────────┘
```

## Platform support

Declared in `Package.swift`:

| Platform   | Minimum |
|------------|---------|
| iOS        | 16      |
| macOS      | 13      |
| tvOS       | 16      |
| visionOS   | 1       |
| watchOS    | 9       |

Swift tools version: **5.10**. Many targets enable the experimental `AccessLevelOnImport` feature.

## Module layers

### CoreMI

**Path:** `Sources/CoreMI`  
**Depends on:** CorePersistence, Merge, Swallow

Foundation types for machine-intelligence services:

- `CoreMI.RequestHandling` — generic generative request interface
- Model identifiers (`ModelIdentifier`, providers, scopes)
- Service client / credential / account protocols
- ASR and TTS request foundations (`TTSRequestHandling`, speech synthesizer types)

### LargeLanguageModels

**Path:** `Sources/LargeLanguageModels`  
**Depends on:** CorePersistence, CoreMI, Merge, NetworkKit, Swallow, SwiftUIX  
**Resources:** `Resources/` (e.g. stopwords)

Provider-agnostic LLM surface:

- `LLMRequestHandling` — chat/text completion and streaming (extends `CoreMI.RequestHandling`)
- `AbstractLLM` — prompts, messages, roles, completion parameters, function calling, agents
- `PromptLiteral` — typed prompt construction (text, images, interpolation)
- `TextEmbeddingsRequestHandling` — embedding requests
- Task dependencies (`TaskDependencyValues.llm`, `.embedding`)

### Provider targets

Each provider lives under `Sources/<Name>` and typically exposes a `Client` that conforms to one or more of:

- `LLMRequestHandling`
- `TextEmbeddingsRequestHandling`
- TTS / speech APIs (where applicable)
- Provider-specific REST models via NetworkKit

| Target | Role (from source layout) | Notable dependencies beyond LLM stack |
|--------|---------------------------|----------------------------------------|
| **OpenAI** | Chat, vision, tools, images, Whisper, TTS, assistants | LargeLanguageModels, Merge, NetworkKit, Swallow |
| **Anthropic** | Claude chat / tools | LargeLanguageModels, Merge, NetworkKit, Swallow |
| **Mistral** | Chat + embeddings | CoreMI, CorePersistence, LLM stack |
| **Groq** | Fast LLM inference | CoreMI, CorePersistence, LLM stack |
| **Ollama** | Local LLM HTTP API | CoreMI, CorePersistence, LLM stack |
| **Perplexity** | Search-oriented LLM | **Also depends on OpenAI** |
| **Cohere** | Embeddings-focused client | CoreMI, CorePersistence, LLM stack |
| **Jina** | Embeddings | CoreMI, CorePersistence, LLM stack |
| **VoyageAI** | Embeddings | CoreMI, CorePersistence, LLM stack |
| **TogetherAI** | Hosted open models / embeddings | CoreMI, CorePersistence, LLM stack |
| **ElevenLabs** | Voice / TTS | CoreMI, CorePersistence, LLM stack |
| **PlayHT** | Voice / TTS | CoreMI, CorePersistence, LLM stack |
| **Rime** | Voice / TTS | CoreMI, CorePersistence, LLM stack |
| **HumeAI** | Empathic voice / chat APIs | CoreMI, CorePersistence, LLM stack |
| **NeetsAI** | Voice / chat | CoreMI, CorePersistence, LLM stack |
| **_Gemini** | Google Gemini (content, files, embeddings, tools) | CoreMI, CorePersistence, LLM stack |
| **HuggingFace** | Hub download / tokenizer resources | **CoreMI, Swallow only** (no LargeLanguageModels) |

### AI (umbrella)

**Path:** `Sources/AI`  
**Depends on:** CoreMI, LargeLanguageModels, Anthropic, Cohere, ElevenLabs, Groq, HuggingFace, Jina, Mistral, Ollama, OpenAI, Swallow

Thin re-export module (`@_exported import …`) so `import AI` pulls in the core stack and several bundled providers. Not every product target is re-exported here (for example `_Gemini`, `Perplexity`, `PlayHT`, `Rime`, `TogetherAI`, `VoyageAI`, `HumeAI`, and `NeetsAI` are separate products).

## Products vs targets

### Umbrella product

```swift
.library(name: "AI", targets: [
  "CoreMI", "LargeLanguageModels",
  "Anthropic", "Cohere", "ElevenLabs", "Groq", "HuggingFace",
  "Jina", "Mistral", "Ollama", "OpenAI", "AI",
])
```

### Standalone products

These can be linked without the full umbrella:

- `_Gemini`, `Anthropic`, `HumeAI`, `NeetsAI`, `OpenAI`, `Perplexity`, `PlayHT`, `Rime`, `TogetherAI`, `VoyageAI`

## Dependency graph (internal)

Derived from `Package.swift` target `dependencies` (external packages collapsed to a single node where helpful).

```mermaid
flowchart TB
  subgraph external [External packages]
    Swallow
    Merge
    NetworkKit
    CorePersistence
    SwiftUIX
  end

  subgraph core [Core]
    CoreMI
    LargeLanguageModels
    HuggingFace
  end

  subgraph providers_llm [LLM providers]
    OpenAI
    Anthropic
    Mistral
    Groq
    Ollama
    Perplexity
    _Gemini
    TogetherAI
    NeetsAI
    HumeAI
  end

  subgraph providers_embed [Embedding-focused]
    Cohere
    Jina
    VoyageAI
  end

  subgraph providers_voice [Voice / TTS]
    ElevenLabs
    PlayHT
    Rime
  end

  subgraph umbrella [Umbrella]
    AI
  end

  CorePersistence --> CoreMI
  Merge --> CoreMI
  Swallow --> CoreMI

  CoreMI --> LargeLanguageModels
  CorePersistence --> LargeLanguageModels
  Merge --> LargeLanguageModels
  NetworkKit --> LargeLanguageModels
  Swallow --> LargeLanguageModels
  SwiftUIX --> LargeLanguageModels

  CoreMI --> HuggingFace
  Swallow --> HuggingFace

  LargeLanguageModels --> OpenAI
  LargeLanguageModels --> Anthropic
  LargeLanguageModels --> Mistral
  LargeLanguageModels --> Groq
  LargeLanguageModels --> Ollama
  LargeLanguageModels --> Perplexity
  LargeLanguageModels --> _Gemini
  LargeLanguageModels --> TogetherAI
  LargeLanguageModels --> NeetsAI
  LargeLanguageModels --> HumeAI
  LargeLanguageModels --> Cohere
  LargeLanguageModels --> Jina
  LargeLanguageModels --> VoyageAI
  LargeLanguageModels --> ElevenLabs
  LargeLanguageModels --> PlayHT
  LargeLanguageModels --> Rime

  OpenAI --> Perplexity

  CoreMI --> AI
  LargeLanguageModels --> AI
  Anthropic --> AI
  Cohere --> AI
  ElevenLabs --> AI
  Groq --> AI
  HuggingFace --> AI
  Jina --> AI
  Mistral --> AI
  Ollama --> AI
  OpenAI --> AI
  Swallow --> AI
```

### Compact target → internal dependency list

| Target | Internal package targets |
|--------|---------------------------|
| CoreMI | — |
| LargeLanguageModels | CoreMI |
| HuggingFace | CoreMI |
| OpenAI | LargeLanguageModels |
| Anthropic | LargeLanguageModels |
| Mistral, Groq, Ollama, Cohere, Jina, VoyageAI, TogetherAI, ElevenLabs, PlayHT, Rime, HumeAI, NeetsAI, _Gemini | CoreMI, LargeLanguageModels |
| Perplexity | CoreMI, LargeLanguageModels, **OpenAI** |
| AI | CoreMI, LargeLanguageModels, Anthropic, Cohere, ElevenLabs, Groq, HuggingFace, Jina, Mistral, Ollama, OpenAI |

## External dependencies

Declared in `Package.swift`:

| Package | URL | Purpose (typical use in this repo) |
|---------|-----|--------------------------------------|
| [Swallow](https://github.com/vmanot/Swallow) | branch `master` | Standard library extensions, macros client, diagnostics utilities |
| [Merge](https://github.com/vmanot/Merge) | branch `master` | Concurrency / async utilities |
| [NetworkKit](https://github.com/vmanot/NetworkKit) | branch `master` | HTTP API client layer for provider specs |
| [CorePersistence](https://github.com/vmanot/CorePersistence) | branch `main` | Persistence / schema helpers (e.g. JSONSchema) |
| [SwiftUIX](https://github.com/SwiftUIX/SwiftUIX) | branch `master` | SwiftUI extensions used by LLM UI-adjacent types |

Resolved transitive pins (see `Package.resolved`) include **SwiftAPI**, **swift-collections**, and **swift-syntax**.

## Tests

Test targets under `Tests/` generally depend on the `AI` umbrella (plus `Swallow`). `_GeminiTests` also depends on `_Gemini` directly.

| Test target | Path |
|-------------|------|
| LargeLanguageModelsTests | `Tests/LargeLanguageModels` |
| AnthropicTests, OpenAITests, MistralTests, GroqTests, … | `Tests/<Provider>` |
| _GeminiTests | `Tests/_Gemini` |

## Design notes

1. **Protocol-oriented providers** — App code can depend on `any LLMRequestHandling` and swap OpenAI, Anthropic, Groq, etc. without rewriting call sites.
2. **Umbrella vs lean imports** — Use `import AI` for convenience, or link a standalone product (e.g. `OpenAI` only) to reduce surface area.
3. **NetworkKit API specs** — Most providers define an `*.APISpecification` and map responses into `AbstractLLM` types.
4. **Experimental Swift features** — `AccessLevelOnImport` is enabled on most targets; keep import access consistent when adding files.

## Related docs

- [README](../README.md) — installation and usage
- [CONTRIBUTING](../CONTRIBUTING.md) — how to extend the package
- [CHANGELOG](../CHANGELOG.md) — release history
