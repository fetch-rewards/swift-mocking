//
//  MockReturningAsyncFunctionWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import XCTest
@testable import Mocked

final class MockReturningAsyncFunctionWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockReturningAsyncFunctionWithoutParameters<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Implementation Tests

    func testImplementationDefaultValue() async {
        await self.test { sut, _ in
            guard case .unimplemented = sut.implementation else {
                XCTFail("Expected default implementation to be unimplemented")
                return
            }
        }
    }

    // MARK: Call Count Tests

    func testCallCountDefaultValue() async {
        await self.test { sut, _ in
            XCTAssertEqual(sut.callCount, .zero)
        }
    }

    func testInvokeIncrementsCallCountWhenImplementationReturnsValue() async {
        await self.test { sut, invoke in
            sut.implementation = .returns { 5 }

            _ = await invoke()
            XCTAssertEqual(sut.callCount, 1)
        }
    }

    // MARK: Return Values Tests

    func testReturnValuesDefaultValue() async {
        await self.test { sut, _ in
            XCTAssertEqual(sut.returnValues, [])
        }
    }

    func testInvokeAppendsReturnValueWhenImplementationReturnsValue() async {
        await self.test { sut, invoke in
            sut.implementation = .returns { 5 }

            _ = await invoke()
            XCTAssertEqual(sut.returnValues, [5])

            sut.implementation = .returns { 10 }

            _ = await invoke()
            XCTAssertEqual(sut.returnValues, [5, 10])
        }
    }

    // MARK: Latest Return Value Tests

    func testLatestReturnValueDefaultValue() async {
        await self.test { sut, _ in
            XCTAssertNil(sut.latestReturnValue)
        }
    }

    func testLatestReturnValueWhenImplementationReturnsValue() async {
        await self.test { sut, invoke in
            sut.implementation = .returns { 5 }

            _ = await invoke()
            XCTAssertEqual(sut.latestReturnValue, 5)

            sut.implementation = .returns { 10 }

            _ = await invoke()
            XCTAssertEqual(sut.latestReturnValue, 10)
        }
    }
}

// MARK: - Helpers

extension MockReturningAsyncFunctionWithoutParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: () async -> ReturnValue
        ) async throws -> Void
    ) async rethrows {
        let (sut, invoke) = SUT.makeFunction(
            exposedFunctionDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )

        try await test(sut, invoke)
    }
}
