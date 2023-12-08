//
//  MockVoidFunctionWithParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidFunctionWithParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidFunctionWithParameters<Arguments>
    typealias Arguments = (string: String, boolean: Bool)

    // MARK: Call Count Tests

    func testCallCount() {
        self.test { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            _ = invoke(("a", true))
            XCTAssertEqual(sut.callCount, 1)
        }
    }

    // MARK: Invocations Tests

    func testInvocations() {
        self.test { sut, invoke in
            XCTAssertTrue(sut.invocations.isEmpty)

            _ = invoke(("a", true))
            XCTAssertEqual(sut.invocations.count, 1)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)

            _ = invoke(("b", false))
            XCTAssertEqual(sut.invocations.count, 2)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)
            XCTAssertEqual(sut.invocations.last?.string, "b")
            XCTAssertEqual(sut.invocations.last?.boolean, false)
        }
    }

    // MARK: Latest Invocation Tests

    func testLatestInvocation() {
        self.test { sut, invoke in
            XCTAssertNil(sut.latestInvocation)

            _ = invoke(("a", true))
            XCTAssertEqual(sut.latestInvocation?.string, "a")
            XCTAssertEqual(sut.latestInvocation?.boolean, true)

            _ = invoke(("b", false))
            XCTAssertEqual(sut.latestInvocation?.string, "b")
            XCTAssertEqual(sut.latestInvocation?.boolean, false)
        }
    }
}

// MARK: - Helpers

extension MockVoidFunctionWithParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: (Arguments) -> Void
        ) -> Void
    ) {
        let (sut, invoke) = SUT.makeFunction()

        test(sut, invoke)
    }
}
