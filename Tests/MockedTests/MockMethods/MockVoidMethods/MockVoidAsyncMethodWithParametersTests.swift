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

    // MARK: Implementation Tests

    func testImplementationDefaultValue() async {
        let (sut, _, _) = SUT.makeMethod()

        guard case .unimplemented = sut.implementation else {
            XCTFail("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    func testCallCount() async {
        let (sut, invoke, reset) = SUT.makeMethod()

        XCTAssertEqual(sut.callCount, .zero)

        await invoke(("a", true))
        XCTAssertEqual(sut.callCount, 1)

        reset()
        XCTAssertEqual(sut.callCount, .zero)
    }

    // MARK: Invocations Tests

    func testInvocations() async {
        let (sut, invoke, reset) = SUT.makeMethod()

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

        reset()
        XCTAssertTrue(sut.invocations.isEmpty)
    }

    // MARK: Last Invocation Tests

    func testLastInvocation() async {
        let (sut, invoke, reset) = SUT.makeMethod()

        XCTAssertNil(sut.lastInvocation)

        await invoke(("a", true))
        XCTAssertEqual(sut.lastInvocation?.string, "a")
        XCTAssertEqual(sut.lastInvocation?.boolean, true)

        await invoke(("b", false))
        XCTAssertEqual(sut.lastInvocation?.string, "b")
        XCTAssertEqual(sut.lastInvocation?.boolean, false)

        reset()
        XCTAssertNil(sut.lastInvocation)
    }
}
