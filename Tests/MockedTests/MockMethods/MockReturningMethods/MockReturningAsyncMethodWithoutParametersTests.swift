//
//  MockReturningAsyncMethodWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import XCTest
@testable import Mocked

final class MockReturningAsyncMethodWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockReturningAsyncMethodWithoutParameters<ReturnValue>
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

            _ = await invoke()
            XCTAssertEqual(sut.callCount, 1)
        }
    }

    // MARK: Returned Values Tests

    func testReturnedValues() async {
        await self.test { sut, invoke in
            XCTAssertEqual(sut.returnedValues, [])

            sut.implementation = .returns { 5 }

            _ = await invoke()
            XCTAssertEqual(sut.returnedValues, [5])

            sut.implementation = .returns { 10 }

            _ = await invoke()
            XCTAssertEqual(sut.returnedValues, [5, 10])
        }
    }

    // MARK: Last Returned Value Tests

    func testLastReturnedValue() async {
        await self.test { sut, invoke in
            XCTAssertNil(sut.lastReturnedValue)

            sut.implementation = .returns { 5 }

            _ = await invoke()
            XCTAssertEqual(sut.lastReturnedValue, 5)

            sut.implementation = .returns { 10 }

            _ = await invoke()
            XCTAssertEqual(sut.lastReturnedValue, 10)
        }
    }
}

// MARK: - Helpers

extension MockReturningAsyncMethodWithoutParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: () async -> ReturnValue
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
