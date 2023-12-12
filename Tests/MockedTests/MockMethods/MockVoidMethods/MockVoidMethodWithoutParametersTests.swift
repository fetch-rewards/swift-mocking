//
//  MockVoidMethodWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidMethodWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidMethodWithoutParameters

    // MARK: Call Count Tests

    func testCallCount() {
        self.test { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            _ = invoke()
            XCTAssertEqual(sut.callCount, 1)
        }
    }
}

// MARK: - Helpers

extension MockVoidMethodWithoutParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: () -> Void
        ) -> Void
    ) {
        let (sut, invoke) = SUT.makeMethod()

        test(sut, invoke)
    }
}
