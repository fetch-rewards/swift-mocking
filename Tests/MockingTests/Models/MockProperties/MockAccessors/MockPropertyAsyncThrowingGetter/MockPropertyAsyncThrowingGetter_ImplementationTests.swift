//
//  MockPropertyAsyncThrowingGetter_ImplementationTests.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Testing
@testable import Mocking

struct MockPropertyAsyncThrowingGetter_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Getter.Implementation
    typealias Getter = MockPropertyAsyncThrowingGetter<Value>
    typealias Value = Int

    // MARK: Call As Function Tests

    @Test
    func unimplemented() async throws {
        let sut: SUT = .unimplemented
        let returnValue = try await sut()

        #expect(returnValue == nil)
    }

    @Test
    func uncheckedInvokes() async throws {
        let sut: SUT = .uncheckedInvokes { 5 }
        let returnValue = try await sut()

        #expect(returnValue == 5)
    }

    @Test
    func uncheckedInvokes_throws() async {
        let sut: SUT = .uncheckedInvokes { throw URLError(.badURL) }

        await #expect(throws: URLError(.badURL)) {
            try await sut()
        }
    }

    @Test
    func uncheckedReturns() async throws {
        let sut: SUT = .uncheckedReturns(5)
        let returnValue = try await sut()

        #expect(returnValue == 5)
    }

    @Test
    func `throws`() async {
        let sut: SUT = .throws(URLError(.badURL))

        await #expect(throws: URLError(.badURL)) {
            try await sut()
        }
    }

    @Test
    func invokes() async throws {
        let sut: SUT = .invokes { 5 }
        let returnValue = try await sut()

        #expect(returnValue == 5)
    }

    @Test
    func returns() async throws {
        let sut: SUT = .returns(5)
        let returnValue = try await sut()

        #expect(returnValue == 5)
    }
}
