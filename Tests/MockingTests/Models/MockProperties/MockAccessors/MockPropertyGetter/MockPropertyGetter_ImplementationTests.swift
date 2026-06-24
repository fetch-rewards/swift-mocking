//
//  MockPropertyGetter_ImplementationTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import Mocking

struct MockPropertyGetter_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Getter.Implementation
    typealias Getter = MockPropertyGetter<Value>
    typealias Value = Int

    // MARK: Call As Function Tests

    @Test
    func unimplemented() {
        let sut: SUT = .unimplemented
        let returnValue = sut()

        #expect(returnValue == nil)
    }

    @Test
    func uncheckedInvokes() {
        let sut: SUT = .uncheckedInvokes { 5 }
        let returnValue = sut()

        #expect(returnValue == 5)
    }

    @Test
    func uncheckedReturns() {
        let sut: SUT = .uncheckedReturns(5)
        let returnValue = sut()

        #expect(returnValue == 5)
    }

    @Test
    func invokes() {
        let sut: SUT = .invokes { 5 }
        let returnValue = sut()

        #expect(returnValue == 5)
    }

    @Test
    func returns() {
        let sut: SUT = .returns(5)
        let returnValue = sut()

        #expect(returnValue == 5)
    }
}
