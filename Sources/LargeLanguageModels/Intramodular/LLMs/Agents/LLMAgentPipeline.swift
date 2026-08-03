//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

// MARK: - Stage protocol

/// A single stage in an LLM-driven agent pipeline.
///
/// Each stage receives a plain-text input, processes it with an LLM using
/// its ``systemPrompt``, and returns a plain-text output that feeds the next stage.
public protocol LLMAgentStage: Sendable {
    /// A human-readable label for this stage (e.g. `"Observer"`).
    var stageName: String { get }

    /// The system prompt that instructs the LLM on how to behave in this stage.
    var systemPrompt: String { get }

    /// Process `input` using `llm` and return the stage's output.
    func process(input: String, using llm: any LLMRequestHandling) async throws -> String
}

extension LLMAgentStage {
    public func process(input: String, using llm: any LLMRequestHandling) async throws -> String {
        let messages: [AbstractLLM.ChatMessage] = [
            .system(systemPrompt),
            .user(input),
        ]
        let completion = try await llm.complete(messages)
        return try completion.toString()
    }
}

// MARK: - Built-in stages

extension AbstractLLM {
    /// Observes raw input (events, signals, changes) and describes what is happening.
    public struct ObserverStage: LLMAgentStage {
        public let stageName: String = "Observer"
        public let systemPrompt: String

        public init(
            systemPrompt: String = """
            You are an observer agent. Given raw input data, events, or signals, \
            clearly describe what is happening. Be concise and factual.
            """
        ) {
            self.systemPrompt = systemPrompt
        }
    }

    /// Analyses observations to discover meaning, patterns, and predictions.
    public struct ResearchStage: LLMAgentStage {
        public let stageName: String = "Research"
        public let systemPrompt: String

        public init(
            systemPrompt: String = """
            You are a research agent. Given an observation, analyse its meaning, \
            identify patterns, and make predictions. Provide a concise analytical summary.
            """
        ) {
            self.systemPrompt = systemPrompt
        }
    }

    /// Takes research results and produces a concrete decision or action recommendation.
    public struct DecisionStage: LLMAgentStage {
        public let stageName: String = "Decision"
        public let systemPrompt: String

        public init(
            systemPrompt: String = """
            You are a decision agent. Given research findings, produce a clear, \
            actionable decision or recommendation. Be direct and specific.
            """
        ) {
            self.systemPrompt = systemPrompt
        }
    }
}

// MARK: - Pipeline result

extension AbstractLLM {
    /// The output produced by each stage of an ``AgentPipeline`` run.
    public struct AgentPipelineResult: Sendable {
        /// Raw input passed into the pipeline.
        public let input: String
        /// Output from the ``ObserverStage``: what is happening.
        public let observation: String
        /// Output from the ``ResearchStage``: what it means.
        public let research: String
        /// Output from the ``DecisionStage``: what to do.
        public let decision: String
    }
}

// MARK: - Pipeline

extension AbstractLLM {
    /// A sequential Observer → Research → Decision agent pipeline.
    ///
    /// Each stage's output becomes the next stage's input, mirroring the
    /// Reality → Observation → Intelligence → Decision flow.
    ///
    /// ```swift
    /// let pipeline = AbstractLLM.AgentPipeline(llm: myLLM)
    /// let result = try await pipeline.run(input: "Server CPU spiked to 98% at 03:00 UTC")
    /// print(result.decision) // "Scale out the web tier by two instances …"
    /// ```
    public struct AgentPipeline: Sendable {
        public let observer: any LLMAgentStage
        public let researcher: any LLMAgentStage
        public let decisionMaker: any LLMAgentStage
        public let llm: any LLMRequestHandling

        public init(
            observer: any LLMAgentStage = ObserverStage(),
            researcher: any LLMAgentStage = ResearchStage(),
            decisionMaker: any LLMAgentStage = DecisionStage(),
            llm: any LLMRequestHandling
        ) {
            self.observer = observer
            self.researcher = researcher
            self.decisionMaker = decisionMaker
            self.llm = llm
        }

        /// Run the full Observer → Research → Decision pipeline on `input`.
        ///
        /// - Parameter input: The raw reality input (events, signals, data).
        /// - Returns: An ``AgentPipelineResult`` containing each stage's output.
        public func run(input: String) async throws -> AgentPipelineResult {
            let observation = try await observer.process(input: input, using: llm)
            let research = try await researcher.process(input: observation, using: llm)
            let decision = try await decisionMaker.process(input: research, using: llm)
            return AgentPipelineResult(
                input: input,
                observation: observation,
                research: research,
                decision: decision
            )
        }
    }
}
