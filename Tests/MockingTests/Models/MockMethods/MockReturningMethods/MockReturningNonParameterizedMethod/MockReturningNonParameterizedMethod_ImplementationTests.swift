//
//  MockReturningNonParameterizedMethod_ImplementationTests.swift
//
//  Copyright © 2025 Fetch.
//

import Testing
@testable import Mocking

struct MockReturningNonParameterizedMethod_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockReturningNonParameterizedMethod<ReturnValue>
    typealias ReturnValue = Int

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
    func invokes() {
        let sut: SUT = .invokes { 5 }
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
    func returns() {
        let sut: SUT = .returns(5)
        let returnValue = sut()

        #expect(returnValue == 5)
    }
}
