//
//  MockReturningFunctionWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import XCTest
@testable import Mocked

final class MockReturningFunctionWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockReturningFunctionWithoutParameters<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Implementation Tests

    func testImplementationDefaultValue() {
        self.test { sut, _ in
            guard case .unimplemented = sut.implementation else {
                XCTFail("Expected implementation to equal .unimplemented")
                return
            }
        }
    }

    // MARK: Call Count Tests

    func testCallCount() {
        self.test { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            sut.implementation = .returns(5)

            _ = invoke()
            XCTAssertEqual(sut.callCount, 1)
        }
    }

    // MARK: Returned Values Tests

    func testReturnedValues() {
        self.test { sut, invoke in
            XCTAssertEqual(sut.returnedValues, [])

            sut.implementation = .returns(5)

            _ = invoke()
            XCTAssertEqual(sut.returnedValues, [5])

            sut.implementation = .returns(10)

            _ = invoke()
            XCTAssertEqual(sut.returnedValues, [5, 10])
        }
    }

    // MARK: Last Returned Value Tests

    func testLastReturnedValue() {
        self.test { sut, invoke in
            XCTAssertNil(sut.lastReturnedValue)

            sut.implementation = .returns(5)

            _ = invoke()
            XCTAssertEqual(sut.lastReturnedValue, 5)

            sut.implementation = .returns(10)

            _ = invoke()
            XCTAssertEqual(sut.lastReturnedValue, 10)
        }
    }
}

// MARK: - Helpers

extension MockReturningFunctionWithoutParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: () -> ReturnValue
        ) -> Void
    ) {
        let (sut, invoke) = SUT.makeFunction(
            exposedFunctionDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )

        test(sut, invoke)
    }
}
