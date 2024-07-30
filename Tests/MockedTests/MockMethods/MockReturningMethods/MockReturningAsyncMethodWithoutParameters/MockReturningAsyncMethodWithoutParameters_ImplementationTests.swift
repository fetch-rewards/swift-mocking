//
//  MockReturningAsyncMethodWithoutParameters_ImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 7/18/24.
//

import XCTest
@testable import Mocked

final class MockReturningAsyncMethodWithoutParameters_ImplementationTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockReturningAsyncMethodWithoutParameters<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Call As Function Tests

    func testReturnsCallAsFunction() async {
        let sut: SUT = .returns { 5 }

        let returnValue = await sut(description: self.description())

        XCTAssertEqual(returnValue, 5)
    }

    func testReturnsConstructorCallAsFunction() async {
        let sut: SUT = .returns(5)

        let returnValue = await sut(description: self.description())

        XCTAssertEqual(returnValue, 5)
    }
}

// MARK: - Helpers

extension MockReturningAsyncMethodWithoutParameters_ImplementationTests {
    private func description() -> MockImplementationDescription {
        MockImplementationDescription(
            type: Self.self,
            member: "sut"
        )
    }
}
