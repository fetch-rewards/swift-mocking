//
//  MockImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockImplementationTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockImplementation<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Call As Function Tests

    func testReturnsCallAsFunction() {
        let sut: SUT = .returns(5)

        let returnValue = sut(description: self.description())

        XCTAssertEqual(returnValue, 5)
    }
}

// MARK: - Helpers

extension MockImplementationTests {
    private func description() -> MockImplementationDescription {
        MockImplementationDescription(
            type: Self.self,
            member: "sut"
        )
    }
}
