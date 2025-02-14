//
//  MockReturningMethodWithParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import XCTest
@testable import Mocked

final class MockReturningMethodWithParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockReturningMethodWithParameters<Arguments, ReturnValue>
    typealias Arguments = (string: String, boolean: Bool)
    typealias ReturnValue = Int

    // MARK: Implementation Tests

    func testImplementationDefaultValue() {
        let (sut, _, _) = self.sut()

        guard case .unimplemented = sut.implementation else {
            XCTFail("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    func testCallCount() {
        let (sut, invoke, reset) = self.sut()

        XCTAssertEqual(sut.callCount, .zero)

        sut.implementation = .returns(5)

        _ = invoke(("a", true))
        XCTAssertEqual(sut.callCount, 1)

        reset()
        XCTAssertEqual(sut.callCount, .zero)
    }

    // MARK: Invocations Tests

    func testInvocations() {
        let (sut, invoke, reset) = self.sut()

        XCTAssertTrue(sut.invocations.isEmpty)

        sut.implementation = .returns(5)

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

        reset()
        XCTAssertTrue(sut.invocations.isEmpty)
    }

    // MARK: Last Invocation Tests

    func testLastInvocation() {
        let (sut, invoke, reset) = self.sut()

        XCTAssertNil(sut.lastInvocation)

        sut.implementation = .returns(5)

        _ = invoke(("a", true))
        XCTAssertEqual(sut.lastInvocation?.string, "a")
        XCTAssertEqual(sut.lastInvocation?.boolean, true)

        _ = invoke(("b", false))
        XCTAssertEqual(sut.lastInvocation?.string, "b")
        XCTAssertEqual(sut.lastInvocation?.boolean, false)

        reset()
        XCTAssertNil(sut.lastInvocation)
    }

    // MARK: Returned Values Tests

    func testReturnedValues() {
        let (sut, invoke, reset) = self.sut()

        XCTAssertEqual(sut.returnedValues, [])

        sut.implementation = .returns(5)

        _ = invoke(("a", true))
        XCTAssertEqual(sut.returnedValues, [5])

        sut.implementation = .returns(10)

        _ = invoke(("b", false))
        XCTAssertEqual(sut.returnedValues, [5, 10])

        reset()
        XCTAssertTrue(sut.returnedValues.isEmpty)
    }

    // MARK: Last Returned Value Tests

    func testLastReturnedValue() {
        let (sut, invoke, reset) = self.sut()

        XCTAssertNil(sut.lastReturnedValue)

        sut.implementation = .returns(5)

        _ = invoke(("a", true))
        XCTAssertEqual(sut.lastReturnedValue, 5)

        sut.implementation = .returns(10)

        _ = invoke(("b", false))
        XCTAssertEqual(sut.lastReturnedValue, 10)

        reset()
        XCTAssertNil(sut.lastReturnedValue)
    }
}

// MARK: - Helpers

extension MockReturningMethodWithParametersTests {
    private func sut() -> (
        method: SUT,
        invoke: (Arguments) -> ReturnValue,
        reset: () -> Void
    ) {
        SUT.makeMethod(
            exposedMethodDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )
    }
}
