//
//  MockVoidNonParameterizedAsyncThrowingMethodTests.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
import Testing
@testable import Mocking

struct MockVoidNonParameterizedAsyncThrowingMethodTests {

    // MARK: Typealiases

    typealias SUT = MockVoidNonParameterizedAsyncThrowingMethod

    // MARK: Implementation Tests

    @Test
    func implementation() async throws {
        let (sut, invoke, reset) = SUT.makeMethod()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }

        try await confirmation(expectedCount: 1) { confirmation in
            sut.implementation = .uncheckedInvokes {
                confirmation.confirm()
            }

            _ = try await invoke()
        }

        reset()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    @Test
    func callCount() async throws {
        let (sut, invoke, reset) = SUT.makeMethod()

        #expect(sut.callCount == .zero)

        try await TestBarrier.executeConcurrently {
            try await invoke()
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        await #expect(throws: URLError(.badURL)) {
            try await TestBarrier.executeConcurrently {
                try await invoke()
            }
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount * 2)

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.callCount == .zero)
    }

    // MARK: Thrown Errors Tests

    @Test
    func thrownErrors() async throws {
        let (sut, invoke, reset) = SUT.makeMethod()

        #expect(sut.thrownErrors.isEmpty)

        try await TestBarrier.executeConcurrently {
            try await invoke()
        }
        #expect(sut.thrownErrors.isEmpty)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        await #expect(throws: URLError(.badURL)) {
            try await TestBarrier.executeConcurrently {
                try await invoke()
            }
        }
        #expect(sut.thrownErrors.count == TestBarrier.defaultTaskCount)

        var firstThrownError = try #require(sut.thrownErrors.first)

        #expect(throws: URLError(.badURL)) {
            throw firstThrownError
        }

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badServerResponse)
        }

        await #expect(throws: URLError(.badServerResponse)) {
            try await TestBarrier.executeConcurrently {
                try await invoke()
            }
        }
        #expect(sut.thrownErrors.count == TestBarrier.defaultTaskCount * 2)

        firstThrownError = try #require(sut.thrownErrors.first)
        let lastThrownError = try #require(sut.thrownErrors.last)

        #expect(throws: URLError(.badURL)) {
            throw firstThrownError
        }
        #expect(throws: URLError(.badServerResponse)) {
            throw lastThrownError
        }

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.thrownErrors.isEmpty)
    }

    // MARK: Last Thrown Error Tests

    @Test
    func lastThrownError() async throws {
        let (sut, invoke, reset) = SUT.makeMethod()

        #expect(sut.lastThrownError == nil)

        try await TestBarrier.executeConcurrently {
            try await invoke()
        }
        #expect(sut.lastThrownError == nil)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        await #expect(throws: URLError(.badURL)) {
            try await TestBarrier.executeConcurrently {
                try await invoke()
            }
        }

        var lastThrownError = try #require(sut.lastThrownError)

        #expect(throws: URLError(.badURL)) {
            throw lastThrownError
        }

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badServerResponse)
        }

        await #expect(throws: URLError(.badServerResponse)) {
            try await TestBarrier.executeConcurrently {
                try await invoke()
            }
        }

        lastThrownError = try #require(sut.lastThrownError)

        #expect(throws: URLError(.badServerResponse)) {
            throw lastThrownError
        }

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.lastThrownError == nil)
    }
}
