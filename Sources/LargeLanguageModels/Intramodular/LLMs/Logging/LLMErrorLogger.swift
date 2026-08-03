//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension AbstractLLM {
    /// A record of an error that occurred during an LLM request.
    public struct ErrorLogEntry: Codable, Hashable, Identifiable, Sendable {
        public let id: UUID
        public let timestamp: Date
        public let modelIdentifier: ModelIdentifier?
        public let promptDescription: String
        public let errorDescription: String

        public init(
            id: UUID = UUID(),
            timestamp: Date = Date(),
            modelIdentifier: ModelIdentifier? = nil,
            promptDescription: String,
            errorDescription: String
        ) {
            self.id = id
            self.timestamp = timestamp
            self.modelIdentifier = modelIdentifier
            self.promptDescription = promptDescription
            self.errorDescription = errorDescription
        }
    }
}

/// A thread-safe logger for errors that occur during LLM requests.
///
/// Errors accumulated here can be reviewed to improve prompt design or to
/// identify patterns in failures. Use
/// ``LLMRequestHandling/complete(_:parameters:loggingErrorsTo:)`` to
/// automatically capture failures from any `LLMRequestHandling` call.
public actor LLMErrorLogger {
    /// The shared, process-wide error logger.
    public static let shared = LLMErrorLogger()

    private var _entries: [AbstractLLM.ErrorLogEntry] = []

    public init() {}

    /// All recorded error entries, in chronological order.
    public var entries: [AbstractLLM.ErrorLogEntry] {
        _entries
    }

    /// Append a new entry to the log.
    public func log(_ entry: AbstractLLM.ErrorLogEntry) {
        _entries.append(entry)
    }

    /// Remove all recorded entries.
    public func clear() {
        _entries.removeAll()
    }
}

// MARK: - LLMRequestHandling integration

extension LLMRequestHandling {
    /// Complete a prompt, automatically logging any thrown error to `logger`.
    ///
    /// On failure the entry is logged and then the error is rethrown so normal
    /// error-handling still applies.
    ///
    /// - Parameters:
    ///   - prompt: The prompt to complete.
    ///   - parameters: Completion parameters.
    ///   - logger: The ``LLMErrorLogger`` to append failures to.
    ///             Defaults to ``LLMErrorLogger/shared``.
    public func complete<Prompt: AbstractLLM.Prompt>(
        _ prompt: Prompt,
        parameters: Prompt.CompletionParameters,
        loggingErrorsTo logger: LLMErrorLogger
    ) async throws -> Prompt.Completion {
        do {
            return try await complete(prompt: prompt, parameters: parameters)
        } catch {
            let modelID = try? prompt.context.modelIdentifier?._oneValue
            let entry = AbstractLLM.ErrorLogEntry(
                modelIdentifier: modelID,
                promptDescription: String(describing: prompt),
                errorDescription: error.localizedDescription
            )
            await logger.log(entry)
            throw error
        }
    }
}
