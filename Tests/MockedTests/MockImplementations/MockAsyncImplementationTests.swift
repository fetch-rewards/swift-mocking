//
//  MockAsyncImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockAsyncImplementationTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockAsyncImplementation<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Call As Function Tests

    func testReturnsCallAsFunction() async {
        let sut: SUT = .returns { 5 }

        let returnValue = await sut(description: self.description())

        XCTAssertEqual(returnValue, 5)
    }
}

// MARK: - Helpers

extension MockAsyncImplementationTests {
    private func description() -> MockImplementationDescription {
        MockImplementationDescription(
            type: Self.self,
            member: "sut"
        )
    }
}
