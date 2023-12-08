//
//  MockReturningAsyncFunctionWithParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import XCTest
@testable import Mocked

final class MockReturningAsyncFunctionWithParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockReturningAsyncFunctionWithParameters<Arguments, ReturnValue>
    typealias Arguments = (integer: Int, boolean: Bool)
    typealias ReturnValue = String

    // MARK: Implementation Tests

    func testImplementationDefaultValue() async {
        await self.test { sut, _ in
            guard case .unimplemented = sut.implementation else {
                XCTFail("Expected implementation to equal .unimplemented")
                return
            }
        }
    }

    // MARK: Call Count Tests

    func testCallCount() async {
        await self.test { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            sut.implementation = .returns { "a" }

            _ = await invoke((5, true))
            XCTAssertEqual(sut.callCount, 1)
        }
    }

    // MARK: Invocations Tests

    func testInvocations() async {
        await self.test { sut, invoke in
            XCTAssertTrue(sut.invocations.isEmpty)

            sut.implementation = .returns { "a" }

            _ = await invoke((5, true))
            XCTAssertEqual(sut.invocations.count, 1)
            XCTAssertEqual(sut.invocations.first?.integer, 5)
            XCTAssertEqual(sut.invocations.first?.boolean, true)

            _ = await invoke((10, false))
            XCTAssertEqual(sut.invocations.count, 2)
            XCTAssertEqual(sut.invocations.first?.integer, 5)
            XCTAssertEqual(sut.invocations.first?.boolean, true)
            XCTAssertEqual(sut.invocations.last?.integer, 10)
            XCTAssertEqual(sut.invocations.last?.boolean, false)
        }
    }

    // MARK: Latest Invocation Tests

    func testLatestInvocation() async {
        await self.test { sut, invoke in
            XCTAssertNil(sut.latestInvocation)

            sut.implementation = .returns { "a" }

            _ = await invoke((5, true))
            XCTAssertEqual(sut.latestInvocation?.integer, 5)
            XCTAssertEqual(sut.latestInvocation?.boolean, true)

            _ = await invoke((10, false))
            XCTAssertEqual(sut.latestInvocation?.integer, 10)
            XCTAssertEqual(sut.latestInvocation?.boolean, false)
        }
    }

    // MARK: Return Values Tests

    func testReturnValues() async {
        await self.test { sut, invoke in
            XCTAssertEqual(sut.returnValues, [])

            sut.implementation = .returns { "a" }

            _ = await invoke((5, true))
            XCTAssertEqual(sut.returnValues, ["a"])

            sut.implementation = .returns { "b" }

            _ = await invoke((10, false))
            XCTAssertEqual(sut.returnValues, ["a", "b"])
        }
    }

    // MARK: Latest Return Value Tests

    func testLatestReturnValue() async {
        await self.test { sut, invoke in
            XCTAssertNil(sut.latestReturnValue)

            sut.implementation = .returns { "a" }

            _ = await invoke((5, true))
            XCTAssertEqual(sut.latestReturnValue, "a")

            sut.implementation = .returns { "b" }

            _ = await invoke((10, false))
            XCTAssertEqual(sut.latestReturnValue, "b")
        }
    }
}

// MARK: - Helpers

extension MockReturningAsyncFunctionWithParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: (Arguments) async -> ReturnValue
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
