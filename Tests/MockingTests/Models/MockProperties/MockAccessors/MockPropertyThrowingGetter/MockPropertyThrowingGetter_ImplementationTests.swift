//
//  MockPropertyThrowingGetter_ImplementationTests.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Testing
@testable import Mocking

struct MockPropertyThrowingGetter_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Getter.Implementation
    typealias Getter = MockPropertyThrowingGetter<Value>
    typealias Value = Int

    // MARK: Call As Function Tests

    @Test
    func unimplemented() throws {
        let sut: SUT = .unimplemented
        let returnValue = try sut()

        #expect(returnValue == nil)
    }

    @Test
    func uncheckedInvokes() throws {
        let sut: SUT = .uncheckedInvokes { 5 }
        let returnValue = try sut()

        #expect(returnValue == 5)
    }

    @Test
    func uncheckedInvokes_throws() {
        let sut: SUT = .uncheckedInvokes { throw URLError(.badURL) }

        #expect(throws: URLError(.badURL)) {
            try sut()
        }
    }

    @Test
    func uncheckedReturns() throws {
        let sut: SUT = .uncheckedReturns(5)
        let returnValue = try sut()

        #expect(returnValue == 5)
    }

    @Test
    func `throws`() {
        let sut: SUT = .throws(URLError(.badURL))

        #expect(throws: URLError(.badURL)) {
            try sut()
        }
    }

    @Test
    func invokes() throws {
        let sut: SUT = .invokes { 5 }
        let returnValue = try sut()

        #expect(returnValue == 5)
    }

    @Test
    func returns() throws {
        let sut: SUT = .returns(5)
        let returnValue = try sut()

        #expect(returnValue == 5)
    }
}
