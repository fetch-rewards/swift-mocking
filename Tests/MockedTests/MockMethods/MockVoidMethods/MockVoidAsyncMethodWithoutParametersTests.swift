//
//  MockVoidAsyncMethodWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidAsyncMethodWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidAsyncMethodWithoutParameters

    // MARK: Call Count Tests

    func testCallCount() async {
        await self.withSUT { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            await invoke()
            XCTAssertEqual(sut.callCount, 1)
        }
    }
}

// MARK: - Helpers

extension MockVoidAsyncMethodWithoutParametersTests {
    private func withSUT(
        test: (
            _ sut: SUT,
            _ invoke: () async -> Void
        ) async -> Void
    ) async {
        let (sut, invoke) = SUT.makeMethod()

        await test(sut, invoke)
    }
}
