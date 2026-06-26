//
//  MockSubscriptThrowingGetter_ImplementationTests.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Testing
@testable import Mocking

struct MockSubscriptThrowingGetter_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Getter.Implementation
    typealias Getter = MockSubscriptThrowingGetter<Arguments, Value>
    typealias Arguments = String
    typealias Value = Int

    // MARK: Call As Function Tests

    @Test
    func unimplemented() throws {
        let sut: SUT = .unimplemented
        let returnValue = try sut("a")

        #expect(returnValue == nil)
    }

    @Test
    func uncheckedInvokes() throws {
        let sut: SUT = .uncheckedInvokes { _ in 5 }
        let returnValue = try sut("a")

        #expect(returnValue == 5)
    }

    @Test
    func uncheckedInvokes_throws() {
        let sut: SUT = .uncheckedInvokes { _ in throw URLError(.badURL) }

        #expect(throws: URLError(.badURL)) {
            try sut("a")
        }
    }

    @Test
    func uncheckedReturns() throws {
        let sut: SUT = .uncheckedReturns(5)
        let returnValue = try sut("a")

        #expect(returnValue == 5)
    }

    @Test
    func `throws`() {
        let sut: SUT = .throws(URLError(.badURL))

        #expect(throws: URLError(.badURL)) {
            try sut("a")
        }
    }

    @Test
    func invokes() throws {
        let sut: SUT = .invokes { _ in 5 }
        let returnValue = try sut("a")

        #expect(returnValue == 5)
    }

    @Test
    func returns() throws {
        let sut: SUT = .returns(5)
        let returnValue = try sut("a")

        #expect(returnValue == 5)
    }
}
