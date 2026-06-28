//
//  MockSubscriptAsyncThrowingGetter_ImplementationTests.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Testing
@testable import Mocking

struct MockSubscriptAsyncThrowingGetter_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Getter.Implementation
    typealias Getter = MockSubscriptAsyncThrowingGetter<Arguments, Value>
    typealias Arguments = String
    typealias Value = Int

    // MARK: Call As Function Tests

    @Test
    func unimplemented() async throws {
        let sut: SUT = .unimplemented
        let returnValue = try await sut("a")

        #expect(returnValue == nil)
    }

    @Test
    func uncheckedInvokes() async throws {
        let sut: SUT = .uncheckedInvokes { _ in 5 }
        let returnValue = try await sut("a")

        #expect(returnValue == 5)
    }

    @Test
    func uncheckedInvokes_throws() async {
        let sut: SUT = .uncheckedInvokes { _ in throw URLError(.badURL) }

        await #expect(throws: URLError(.badURL)) {
            try await sut("a")
        }
    }

    @Test
    func uncheckedReturns() async throws {
        let sut: SUT = .uncheckedReturns(5)
        let returnValue = try await sut("a")

        #expect(returnValue == 5)
    }

    @Test
    func `throws`() async {
        let sut: SUT = .throws(URLError(.badURL))

        await #expect(throws: URLError(.badURL)) {
            try await sut("a")
        }
    }

    @Test
    func invokes() async throws {
        let sut: SUT = .invokes { _ in 5 }
        let returnValue = try await sut("a")

        #expect(returnValue == 5)
    }

    @Test
    func returns() async throws {
        let sut: SUT = .returns(5)
        let returnValue = try await sut("a")

        #expect(returnValue == 5)
    }
}
