//
//  MockSubscriptGetter_ImplementationTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import Mocking

struct MockSubscriptGetter_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Getter.Implementation
    typealias Getter = MockSubscriptGetter<Key, Value>
    typealias Key = String
    typealias Value = Int

    // MARK: Call As Function Tests

    @Test
    func unimplemented() {
        let sut: SUT = .unimplemented
        let returnValue = sut("a")

        #expect(returnValue == nil)
    }

    @Test
    func uncheckedInvokes() {
        let sut: SUT = .uncheckedInvokes { _ in 5 }
        let returnValue = sut("a")

        #expect(returnValue == 5)
    }

    @Test
    func uncheckedReturns() {
        let sut: SUT = .uncheckedReturns(5)
        let returnValue = sut("a")

        #expect(returnValue == 5)
    }

    @Test
    func invokes() {
        let sut: SUT = .invokes { _ in 5 }
        let returnValue = sut("a")

        #expect(returnValue == 5)
    }

    @Test
    func returns() {
        let sut: SUT = .returns(5)
        let returnValue = sut("a")

        #expect(returnValue == 5)
    }
}
