//
//  MockReturningFunctionWithParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import XCTest
@testable import Mocked

final class MockReturningFunctionWithParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockReturningFunctionWithParameters<Arguments, ReturnValue>
    typealias Arguments = (string: String, boolean: Bool)
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

            _ = invoke(("a", true))
            XCTAssertEqual(sut.callCount, 1)
        }
    }

    // MARK: Invocations Tests

    func testInvocations() {
        self.test { sut, invoke in
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
        }
    }

    // MARK: Latest Invocation Tests

    func testLatestInvocation() {
        self.test { sut, invoke in
            XCTAssertNil(sut.latestInvocation)

            sut.implementation = .returns(5)

            _ = invoke(("a", true))
            XCTAssertEqual(sut.latestInvocation?.string, "a")
            XCTAssertEqual(sut.latestInvocation?.boolean, true)

            _ = invoke(("b", false))
            XCTAssertEqual(sut.latestInvocation?.string, "b")
            XCTAssertEqual(sut.latestInvocation?.boolean, false)
        }
    }

    // MARK: Return Values Tests

    func testReturnValues() {
        self.test { sut, invoke in
            XCTAssertEqual(sut.returnValues, [])

            sut.implementation = .returns(5)

            _ = invoke(("a", true))
            XCTAssertEqual(sut.returnValues, [5])

            sut.implementation = .returns(10)

            _ = invoke(("b", false))
            XCTAssertEqual(sut.returnValues, [5, 10])
        }
    }

    // MARK: Latest Return Value Tests

    func testLatestReturnValue() {
        self.test { sut, invoke in
            XCTAssertNil(sut.latestReturnValue)

            sut.implementation = .returns(5)

            _ = invoke(("a", true))
            XCTAssertEqual(sut.latestReturnValue, 5)

            sut.implementation = .returns(10)

            _ = invoke(("b", false))
            XCTAssertEqual(sut.latestReturnValue, 10)
        }
    }
}

// MARK: - Helpers

extension MockReturningFunctionWithParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: (Arguments) -> ReturnValue
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
