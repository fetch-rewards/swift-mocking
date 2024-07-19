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
        let (sut, _) = self.sut()

        guard case .unimplemented = sut.implementation else {
            XCTFail("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    func testCallCount() async {
        let (sut, invoke) = self.sut()

        XCTAssertEqual(sut.callCount, .zero)

        sut.implementation = .returns(5)

        _ = await invoke()
        XCTAssertEqual(sut.callCount, 1)
    }

    // MARK: Returned Values Tests

    func testReturnedValues() async {
        let (sut, invoke) = self.sut()
        
        XCTAssertEqual(sut.returnedValues, [])

        sut.implementation = .returns(5)

        _ = await invoke()
        XCTAssertEqual(sut.returnedValues, [5])

        sut.implementation = .returns(10)

        _ = await invoke()
        XCTAssertEqual(sut.returnedValues, [5, 10])
    }

    // MARK: Last Returned Value Tests

    func testLastReturnedValue() async {
        let (sut, invoke) = self.sut()

        XCTAssertNil(sut.lastReturnedValue)

        sut.implementation = .returns(5)

        _ = await invoke()
        XCTAssertEqual(sut.lastReturnedValue, 5)

        sut.implementation = .returns(10)

        _ = await invoke()
        XCTAssertEqual(sut.lastReturnedValue, 10)
    }
}

// MARK: - Helpers

extension MockReturningAsyncMethodWithoutParametersTests {
    private func sut() -> (
        method: SUT,
        invoke: () async -> ReturnValue
    ) {
        SUT.makeMethod(
            exposedMethodDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )
    }
}
