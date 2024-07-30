//
//  MockVoidMethodWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidMethodWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidMethodWithoutParameters

    // MARK: Implementation Tests

    func testImplementationDefaultValue() async {
        let (sut, _) = SUT.makeMethod()

        guard case .unimplemented = sut.implementation else {
            XCTFail("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    func testCallCount() {
        let (sut, invoke) = SUT.makeMethod()

        XCTAssertEqual(sut.callCount, .zero)

        invoke()
        XCTAssertEqual(sut.callCount, 1)
    }
}
