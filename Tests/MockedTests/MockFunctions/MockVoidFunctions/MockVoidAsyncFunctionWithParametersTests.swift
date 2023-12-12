//
//  MockVoidAsyncFunctionWithParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidAsyncFunctionWithParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidAsyncFunctionWithParameters<Arguments>
    typealias Arguments = (string: String, boolean: Bool)

    // MARK: Call Count Tests

    func testCallCount() async {
        await self.test { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            _ = await invoke(("a", true))
            XCTAssertEqual(sut.callCount, 1)
        }
    }

    // MARK: Invocations Tests

    func testInvocations() async {
        await self.test { sut, invoke in
            XCTAssertTrue(sut.invocations.isEmpty)

            _ = await invoke(("a", true))
            XCTAssertEqual(sut.invocations.count, 1)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)

            _ = await invoke(("b", false))
            XCTAssertEqual(sut.invocations.count, 2)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)
            XCTAssertEqual(sut.invocations.last?.string, "b")
            XCTAssertEqual(sut.invocations.last?.boolean, false)
        }
    }

    // MARK: Last Invocation Tests

    func testLastInvocation() async {
        await self.test { sut, invoke in
            XCTAssertNil(sut.lastInvocation)

            _ = await invoke(("a", true))
            XCTAssertEqual(sut.lastInvocation?.string, "a")
            XCTAssertEqual(sut.lastInvocation?.boolean, true)

            _ = await invoke(("b", false))
            XCTAssertEqual(sut.lastInvocation?.string, "b")
            XCTAssertEqual(sut.lastInvocation?.boolean, false)
        }
    }
}

// MARK: - Helpers

extension MockVoidAsyncFunctionWithParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: (Arguments) async -> Void
        ) async -> Void
    ) async {
        let (sut, invoke) = SUT.makeFunction()

        await test(sut, invoke)
    }
}
