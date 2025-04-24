//
//  MockVoidNonParameterizedThrowingMethodTests.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation
import Testing
@testable import Mocking

struct MockVoidNonParameterizedThrowingMethodTests {

    // MARK: Typealiases

    typealias SUT = MockVoidNonParameterizedThrowingMethod

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

            _ = try invoke()
        }

        reset()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    @Test
    func callCount() throws {
        let (sut, invoke, reset) = SUT.makeMethod()

        #expect(sut.callCount == .zero)

        try invoke()
        #expect(sut.callCount == 1)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        #expect(throws: URLError(.badURL)) {
            try invoke()
        }
        #expect(sut.callCount == 2)

        reset()
        #expect(sut.callCount == .zero)
    }

    // MARK: Thrown Errors Tests

    @Test
    func thrownErrors() throws {
        let (sut, invoke, reset) = SUT.makeMethod()

        #expect(sut.thrownErrors.isEmpty)

        try invoke()
        #expect(sut.thrownErrors.isEmpty)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        #expect(throws: URLError(.badURL)) {
            try invoke()
        }
        #expect(sut.thrownErrors.count == 1)

        var firstThrownError = try #require(sut.thrownErrors.first)

        #expect(throws: URLError(.badURL)) {
            throw firstThrownError
        }

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badServerResponse)
        }

        #expect(throws: URLError(.badServerResponse)) {
            try invoke()
        }
        #expect(sut.thrownErrors.count == 2)

        firstThrownError = try #require(sut.thrownErrors.first)
        let lastThrownError = try #require(sut.lastThrownError)

        #expect(throws: URLError(.badURL)) {
            throw firstThrownError
        }
        #expect(throws: URLError(.badServerResponse)) {
            throw lastThrownError
        }

        reset()
        #expect(sut.thrownErrors.isEmpty)
    }

    // MARK: Last Thrown Error Tests

    @Test
    func lastThrownError() throws {
        let (sut, invoke, reset) = SUT.makeMethod()

        #expect(sut.lastThrownError == nil)

        try invoke()
        #expect(sut.lastThrownError == nil)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        #expect(throws: URLError(.badURL)) {
            try invoke()
        }

        var lastThrownError = try #require(sut.lastThrownError)

        #expect(throws: URLError(.badURL)) {
            throw lastThrownError
        }

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badServerResponse)
        }

        #expect(throws: URLError(.badServerResponse)) {
            try invoke()
        }

        lastThrownError = try #require(sut.lastThrownError)

        #expect(throws: URLError(.badServerResponse)) {
            throw lastThrownError
        }

        reset()
        #expect(sut.lastThrownError == nil)
    }
}
