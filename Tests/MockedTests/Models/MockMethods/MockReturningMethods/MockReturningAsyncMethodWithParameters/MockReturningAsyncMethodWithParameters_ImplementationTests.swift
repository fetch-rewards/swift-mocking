//
//  MockReturningAsyncMethodWithParameters_ImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 7/18/24.
//

import XCTest
@testable import Mocked

final class MockReturningAsyncMethodWithParameters_ImplementationTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockReturningAsyncMethodWithParameters<Arguments, ReturnValue>
    typealias Arguments = (string: String, boolean: Bool)
    typealias ReturnValue = Int

    // MARK: Call As Function Tests

    func testReturnsCallAsFunction() async {
        let sut: SUT = .returns { arguments in
            XCTAssertEqual(arguments.string, "A")
            XCTAssertTrue(arguments.boolean)

            return 5
        }

        let returnValue = await sut(
            arguments: ("A", true),
            description: self.description()
        )

        XCTAssertEqual(returnValue, 5)
    }

    func testReturnsConstructorCallAsFunction() async {
        let sut: SUT = .returns(5)

        let returnValue = await sut(
            arguments: ("A", true),
            description: self.description()
        )

        XCTAssertEqual(returnValue, 5)
    }
}

// MARK: - Helpers

extension MockReturningAsyncMethodWithParameters_ImplementationTests {
    private func description() -> MockImplementationDescription {
        MockImplementationDescription(
            type: Self.self,
            member: "sut"
        )
    }
}
