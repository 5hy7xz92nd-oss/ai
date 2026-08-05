//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension AbstractLLM {
    /// A record of a chat completion request that resulted in an error.
    ///
    /// These records can be exported and used to improve prompts or to build a
    /// fine-tuning dataset that corrects known failure modes.
    public struct FailedChatResponse: Codable, Hashable, Identifiable, Sendable {
        public let id: UUID
        public let timestamp: Date
        public let modelIdentifier: ModelIdentifier?
        public let prompt: [AbstractLLM.ChatMessage]
        public let errorDescription: String

        public init(
            id: UUID = UUID(),
            timestamp: Date = Date(),
            modelIdentifier: ModelIdentifier? = nil,
            prompt: [AbstractLLM.ChatMessage],
            errorDescription: String
        ) {
            self.id = id
            self.timestamp = timestamp
            self.modelIdentifier = modelIdentifier
            self.prompt = prompt
            self.errorDescription = errorDescription
        }
    }
}

/// A thread-safe store for chat completion requests that resulted in errors.
///
/// Accumulated entries can be exported as JSONL for use in fine-tuning
/// pipelines that teach models to handle or avoid past failure patterns.
public actor FailedLLMResponseStore {
    /// The shared, process-wide failed-response store.
    public static let shared = FailedLLMResponseStore()

    private var _entries: [AbstractLLM.FailedChatResponse] = []

    public init() {}

    /// All recorded failed responses, in chronological order.
    public var entries: [AbstractLLM.FailedChatResponse] {
        _entries
    }

    /// Append a new failed-response record.
    public func record(_ entry: AbstractLLM.FailedChatResponse) {
        _entries.append(entry)
    }

    /// Remove all recorded entries.
    public func clear() {
        _entries.removeAll()
    }

    /// Export all entries as a JSONL string.
    ///
    /// Each line is a JSON object representing one ``AbstractLLM/FailedChatResponse``.
    /// The output is suitable for ingestion by fine-tuning pipelines that use
    /// the JSONL format (e.g. OpenAI fine-tuning, Axolotl, Unsloth).
    public func exportAsJSONL() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = []
        encoder.dateEncodingStrategy = .iso8601
        return try _entries
            .map { try String(decoding: encoder.encode($0), as: UTF8.self) }
            .joined(separator: "\n")
    }
}

// MARK: - LLMRequestHandling integration

extension LLMRequestHandling {
    /// Complete a chat prompt, automatically recording any failure in `store`.
    ///
    /// On failure the record is appended to `store` and then the error is
    /// rethrown so normal error-handling still applies.
    ///
    /// - Parameters:
    ///   - prompt: The chat prompt to complete.
    ///   - parameters: Completion parameters.
    ///   - store: The ``FailedLLMResponseStore`` to append failures to.
    public func complete(
        prompt: AbstractLLM.ChatPrompt,
        parameters: AbstractLLM.ChatCompletionParameters,
        recordingFailuresIn store: FailedLLMResponseStore
    ) async throws -> AbstractLLM.ChatCompletion {
        do {
            return try await complete(prompt: prompt, parameters: parameters)
        } catch {
            let modelID = try? prompt.context.modelIdentifier?._oneValue
            let entry = AbstractLLM.FailedChatResponse(
                modelIdentifier: modelID,
                prompt: prompt.messages,
                errorDescription: error.localizedDescription
            )
            await store.record(entry)
            throw error
        }
    }
}
