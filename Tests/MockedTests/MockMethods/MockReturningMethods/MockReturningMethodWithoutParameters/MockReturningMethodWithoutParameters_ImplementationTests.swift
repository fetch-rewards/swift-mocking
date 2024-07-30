//
//  MockReturningMethodWithoutParameters_ImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 7/18/24.
//

import XCTest
@testable import Mocked

final class MockReturningMethodWithoutParameters_ImplementationTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockReturningMethodWithoutParameters<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Call As Function Tests

    func testReturnsCallAsFunction() {
        let sut: SUT = .returns { 5 }

        let returnValue = sut(description: self.description())

        XCTAssertEqual(returnValue, 5)
    }

    func testReturnsConstructorCallAsFunction() {
        let sut: SUT = .returns(5)

        let returnValue = sut(description: self.description())

        XCTAssertEqual(returnValue, 5)
    }
}

// MARK: - Helpers

extension MockReturningMethodWithoutParameters_ImplementationTests {
    private func description() -> MockImplementationDescription {
        MockImplementationDescription(
            type: Self.self,
            member: "sut"
        )
    }
}
