//
//  MockReturningMethodWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import XCTest
@testable import Mocked

final class MockReturningMethodWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockReturningMethodWithoutParameters<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Implementation Tests

    func testImplementationDefaultValue() {
        let (sut, _) = self.sut()

        guard case .unimplemented = sut.implementation else {
            XCTFail("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    func testCallCount() {
        let (sut, invoke) = self.sut()

        XCTAssertEqual(sut.callCount, .zero)

        sut.implementation = .returns(5)

        _ = invoke()
        XCTAssertEqual(sut.callCount, 1)
    }

    // MARK: Returned Values Tests

    func testReturnedValues() {
        let (sut, invoke) = self.sut()

        XCTAssertEqual(sut.returnedValues, [])

        sut.implementation = .returns(5)

        _ = invoke()
        XCTAssertEqual(sut.returnedValues, [5])

        sut.implementation = .returns(10)

        _ = invoke()
        XCTAssertEqual(sut.returnedValues, [5, 10])
    }

    // MARK: Last Returned Value Tests

    func testLastReturnedValue() {
        let (sut, invoke) = self.sut()

        XCTAssertNil(sut.lastReturnedValue)

        sut.implementation = .returns(5)

        _ = invoke()
        XCTAssertEqual(sut.lastReturnedValue, 5)

        sut.implementation = .returns(10)

        _ = invoke()
        XCTAssertEqual(sut.lastReturnedValue, 10)
    }
}

// MARK: - Helpers

extension MockReturningMethodWithoutParametersTests {
    private func sut() -> (
        method: SUT,
        invoke: () -> ReturnValue
    ) {
        SUT.makeMethod(
            exposedMethodDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )
    }
}
