//
//  MockReturningAsyncMethodWithParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import XCTest
@testable import Mocked

final class MockReturningAsyncMethodWithParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockReturningAsyncMethodWithParameters<Arguments, ReturnValue>
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

    // MARK: Last Invocation Tests

    func testLastInvocation() async {
        await self.test { sut, invoke in
            XCTAssertNil(sut.lastInvocation)

            sut.implementation = .returns { 5 }

            _ = await invoke(("a", true))
            XCTAssertEqual(sut.lastInvocation?.string, "a")
            XCTAssertEqual(sut.lastInvocation?.boolean, true)

            _ = await invoke(("b", false))
            XCTAssertEqual(sut.lastInvocation?.string, "b")
            XCTAssertEqual(sut.lastInvocation?.boolean, false)
        }
    }

    // MARK: Returned Values Tests

    func testReturnedValues() async {
        await self.test { sut, invoke in
            XCTAssertEqual(sut.returnedValues, [])

            sut.implementation = .returns { 5 }

            _ = await invoke(("a", true))
            XCTAssertEqual(sut.returnedValues, [5])

            sut.implementation = .returns { 10 }

            _ = await invoke(("b", false))
            XCTAssertEqual(sut.returnedValues, [5, 10])
        }
    }

    // MARK: Last Returned Value Tests

    func testLastReturnedValue() async {
        await self.test { sut, invoke in
            XCTAssertNil(sut.lastReturnedValue)

            sut.implementation = .returns { 5 }

            _ = await invoke(("a", true))
            XCTAssertEqual(sut.lastReturnedValue, 5)

            sut.implementation = .returns { 10 }

            _ = await invoke(("b", false))
            XCTAssertEqual(sut.lastReturnedValue, 10)
        }
    }
}

// MARK: - Helpers

extension MockReturningAsyncMethodWithParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: (Arguments) async -> ReturnValue
        ) async -> Void
    ) async {
        let (sut, invoke) = SUT.makeMethod(
            exposedMethodDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )

        await test(sut, invoke)
    }
}
