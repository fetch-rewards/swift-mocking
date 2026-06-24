//
//  MockPropertyAsyncGetter_ImplementationTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import Mocking

struct MockPropertyAsyncGetter_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Getter.Implementation
    typealias Getter = MockPropertyAsyncGetter<Value>
    typealias Value = Int

    // MARK: Call As Function Tests

    @Test
    func unimplemented() async {
        let sut: SUT = .unimplemented
        let returnValue = await sut()

        #expect(returnValue == nil)
    }

    @Test
    func uncheckedInvokes() async {
        let sut: SUT = .uncheckedInvokes { 5 }
        let returnValue = await sut()

        #expect(returnValue == 5)
    }

    @Test
    func uncheckedReturns() async {
        let sut: SUT = .uncheckedReturns(5)
        let returnValue = await sut()

        #expect(returnValue == 5)
    }

    @Test
    func invokes() async {
        let sut: SUT = .invokes { 5 }
        let returnValue = await sut()

        #expect(returnValue == 5)
    }

    @Test
    func returns() async {
        let sut: SUT = .returns(5)
        let returnValue = await sut()

        #expect(returnValue == 5)
    }
}
