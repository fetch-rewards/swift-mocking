//
//  MockReturningMethodWithParameters_ImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 7/18/24.
//

import XCTest
@testable import Mocked

final class MockReturningMethodWithParameters_ImplementationTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockReturningMethodWithParameters<Arguments, ReturnValue>
    typealias Arguments = (string: String, boolean: Bool)
    typealias ReturnValue = Int

    // MARK: Call As Function Tests

    func testReturnsCallAsFunction() {
        let sut: SUT = .returns { arguments in
            XCTAssertEqual(arguments.string, "A")
            XCTAssertTrue(arguments.boolean)

            return 5
        }

        let returnValue = sut(
            arguments: ("A", true),
            description: self.description()
        )

        XCTAssertEqual(returnValue, 5)
    }

    func testReturnsConstructorCallAsFunction() {
        let sut: SUT = .returns(5)

        let returnValue = sut(
            arguments: ("A", true),
            description: self.description()
        )

        XCTAssertEqual(returnValue, 5)
    }
}

// MARK: - Helpers

extension MockReturningMethodWithParameters_ImplementationTests {
    private func description() -> MockImplementationDescription {
        MockImplementationDescription(
            type: Self.self,
            member: "sut"
        )
    }
}
