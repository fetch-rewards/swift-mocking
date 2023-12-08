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
    typealias Arguments = (string: String, boolean: Bool)
    typealias ReturnValue = Int

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

            sut.implementation = .returns { 5 }

            _ = await invoke(("a", true))
            XCTAssertEqual(sut.callCount, 1)
        }
    }

    // MARK: Invocations Tests

    func testInvocations() async {
        await self.test { sut, invoke in
            XCTAssertTrue(sut.invocations.isEmpty)

            sut.implementation = .returns { 5 }

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

    // MARK: Latest Invocation Tests

    func testLatestInvocation() async {
        await self.test { sut, invoke in
            XCTAssertNil(sut.latestInvocation)

            sut.implementation = .returns { 5 }

            _ = await invoke(("a", true))
            XCTAssertEqual(sut.latestInvocation?.string, "a")
            XCTAssertEqual(sut.latestInvocation?.boolean, true)

            _ = await invoke(("b", false))
            XCTAssertEqual(sut.latestInvocation?.string, "b")
            XCTAssertEqual(sut.latestInvocation?.boolean, false)
        }
    }

    // MARK: Return Values Tests

    func testReturnValues() async {
        await self.test { sut, invoke in
            XCTAssertEqual(sut.returnValues, [])

            sut.implementation = .returns { 5 }

            _ = await invoke(("a", true))
            XCTAssertEqual(sut.returnValues, [5])

            sut.implementation = .returns { 10 }

            _ = await invoke(("b", false))
            XCTAssertEqual(sut.returnValues, [5, 10])
        }
    }

    // MARK: Latest Return Value Tests

    func testLatestReturnValue() async {
        await self.test { sut, invoke in
            XCTAssertNil(sut.latestReturnValue)

            sut.implementation = .returns { 5 }

            _ = await invoke(("a", true))
            XCTAssertEqual(sut.latestReturnValue, 5)

            sut.implementation = .returns { 10 }

            _ = await invoke(("b", false))
            XCTAssertEqual(sut.latestReturnValue, 10)
        }
    }
}

// MARK: - Helpers

extension MockReturningAsyncFunctionWithParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: (Arguments) async -> ReturnValue
        ) async -> Void
    ) async {
        let (sut, invoke) = SUT.makeFunction(
            exposedFunctionDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )

        await test(sut, invoke)
    }
}
