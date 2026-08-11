# Architecture

This document summarizes the package architecture as defined in `Package.swift`.

## Module Layers

1. **Core layer**
   - `CoreMI`
2. **LLM abstraction layer**
   - `LargeLanguageModels`
3. **Provider layer**
   - `Anthropic`, `Cohere`, `ElevenLabs`, `Groq`, `HuggingFace`, `HumeAI`, `Jina`, `Mistral`, `NeetsAI`, `Ollama`, `OpenAI`, `Perplexity`, `PlayHT`, `Rime`, `TogetherAI`, `VoyageAI`, `_Gemini`
4. **Umbrella layer**
   - `AI`

## Component Dependency Graph

```mermaid
graph TD
    CoreMI --> CorePersistence
    CoreMI --> Merge
    CoreMI --> Swallow

    LargeLanguageModels --> CoreMI
    LargeLanguageModels --> CorePersistence
    LargeLanguageModels --> Merge
    LargeLanguageModels --> NetworkKit
    LargeLanguageModels --> Swallow
    LargeLanguageModels --> SwiftUIX

    Anthropic --> LargeLanguageModels
    OpenAI --> LargeLanguageModels
    HuggingFace --> CoreMI

    Cohere --> CoreMI
    Cohere --> LargeLanguageModels
    ElevenLabs --> CoreMI
    ElevenLabs --> LargeLanguageModels
    Groq --> CoreMI
    Groq --> LargeLanguageModels
    HumeAI --> CoreMI
    HumeAI --> LargeLanguageModels
    Jina --> CoreMI
    Jina --> LargeLanguageModels
    Mistral --> CoreMI
    Mistral --> LargeLanguageModels
    NeetsAI --> CoreMI
    NeetsAI --> LargeLanguageModels
    Ollama --> CoreMI
    Ollama --> LargeLanguageModels
    PlayHT --> CoreMI
    PlayHT --> LargeLanguageModels
    Rime --> CoreMI
    Rime --> LargeLanguageModels
    TogetherAI --> CoreMI
    TogetherAI --> LargeLanguageModels
    VoyageAI --> CoreMI
    VoyageAI --> LargeLanguageModels
    _Gemini --> CoreMI
    _Gemini --> LargeLanguageModels

    Perplexity --> OpenAI
    Perplexity --> CoreMI
    Perplexity --> LargeLanguageModels

    AI --> CoreMI
    AI --> LargeLanguageModels
    AI --> Anthropic
    AI --> Cohere
    AI --> ElevenLabs
    AI --> Groq
    AI --> HuggingFace
    AI --> Jina
    AI --> Mistral
    AI --> Ollama
    AI --> OpenAI

    AI -. standalone product .-> HumeAI
    AI -. standalone product .-> NeetsAI
    AI -. standalone product .-> Perplexity
    AI -. standalone product .-> PlayHT
    AI -. standalone product .-> Rime
    AI -. standalone product .-> TogetherAI
    AI -. standalone product .-> VoyageAI
    AI -. standalone product .-> _Gemini
```
> Note: The `AI` umbrella target currently depends on `CoreMI`, `LargeLanguageModels`, `Anthropic`, `Cohere`, `ElevenLabs`, `Groq`, `HuggingFace`, `Jina`, `Mistral`, `Ollama`, and `OpenAI`. Other provider modules in this repository are distributed as standalone products and are not re-exported by `AI` in `Package.swift`.

## External Dependencies

- `CorePersistence`
- `Merge`
- `NetworkKit`
- `Swallow`
- `SwiftUIX`
