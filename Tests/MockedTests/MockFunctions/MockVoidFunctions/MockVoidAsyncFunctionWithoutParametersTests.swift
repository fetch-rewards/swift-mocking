//
//  MockVoidAsyncFunctionWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidAsyncFunctionWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidAsyncFunctionWithoutParameters

    // MARK: Call Count Tests

    func testCallCount() async {
        await self.test { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            _ = await invoke()
            XCTAssertEqual(sut.callCount, 1)
        }
    }
}

// MARK: - Helpers

extension MockVoidAsyncFunctionWithoutParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: () async -> Void
        ) async -> Void
    ) async {
        let (sut, invoke) = SUT.makeFunction()

        await test(sut, invoke)
    }
}
