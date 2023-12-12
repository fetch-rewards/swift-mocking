//
//  MockVoidMethodWithParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidMethodWithParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidMethodWithParameters<Arguments>
    typealias Arguments = (string: String, boolean: Bool)

    // MARK: Call Count Tests

    func testCallCount() {
        self.withSUT { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            invoke(("a", true))
            XCTAssertEqual(sut.callCount, 1)
        }
    }

    // MARK: Invocations Tests

    func testInvocations() {
        self.withSUT { sut, invoke in
            XCTAssertTrue(sut.invocations.isEmpty)

            invoke(("a", true))
            XCTAssertEqual(sut.invocations.count, 1)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)

            invoke(("b", false))
            XCTAssertEqual(sut.invocations.count, 2)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)
            XCTAssertEqual(sut.invocations.last?.string, "b")
            XCTAssertEqual(sut.invocations.last?.boolean, false)
        }
    }

    // MARK: Last Invocation Tests

    func testLastInvocation() {
        self.withSUT { sut, invoke in
            XCTAssertNil(sut.lastInvocation)

            invoke(("a", true))
            XCTAssertEqual(sut.lastInvocation?.string, "a")
            XCTAssertEqual(sut.lastInvocation?.boolean, true)

            invoke(("b", false))
            XCTAssertEqual(sut.lastInvocation?.string, "b")
            XCTAssertEqual(sut.lastInvocation?.boolean, false)
        }
    }
}

// MARK: - Helpers

extension MockVoidMethodWithParametersTests {
    private func withSUT(
        test: (
            _ sut: SUT,
            _ invoke: (Arguments) -> Void
        ) -> Void
    ) {
        let (sut, invoke) = SUT.makeMethod()

        test(sut, invoke)
    }
}
