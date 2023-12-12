//
//  MockVoidAsyncMethodWithParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidAsyncMethodWithParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidAsyncMethodWithParameters<Arguments>
    typealias Arguments = (string: String, boolean: Bool)

    // MARK: Call Count Tests

    func testCallCount() async {
        await self.withSUT { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            await invoke(("a", true))
            XCTAssertEqual(sut.callCount, 1)
        }
    }

    // MARK: Invocations Tests

    func testInvocations() async {
        await self.withSUT { sut, invoke in
            XCTAssertTrue(sut.invocations.isEmpty)

            await invoke(("a", true))
            XCTAssertEqual(sut.invocations.count, 1)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)

            await invoke(("b", false))
            XCTAssertEqual(sut.invocations.count, 2)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)
            XCTAssertEqual(sut.invocations.last?.string, "b")
            XCTAssertEqual(sut.invocations.last?.boolean, false)
        }
    }

    // MARK: Last Invocation Tests

    func testLastInvocation() async {
        await self.withSUT { sut, invoke in
            XCTAssertNil(sut.lastInvocation)

            await invoke(("a", true))
            XCTAssertEqual(sut.lastInvocation?.string, "a")
            XCTAssertEqual(sut.lastInvocation?.boolean, true)

            await invoke(("b", false))
            XCTAssertEqual(sut.lastInvocation?.string, "b")
            XCTAssertEqual(sut.lastInvocation?.boolean, false)
        }
    }
}

// MARK: - Helpers

extension MockVoidAsyncMethodWithParametersTests {
    private func withSUT(
        test: (
            _ sut: SUT,
            _ invoke: (Arguments) async -> Void
        ) async -> Void
    ) async {
        let (sut, invoke) = SUT.makeMethod()

        await test(sut, invoke)
    }
}
