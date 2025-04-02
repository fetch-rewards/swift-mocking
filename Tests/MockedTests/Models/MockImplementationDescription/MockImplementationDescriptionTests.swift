//
//  MockImplementationDescriptionTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockImplementationDescriptionTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockImplementationDescription

    // MARK: Debug Description Tests

    func testDebugDescription() {
        let sut = SUT(type: Self.self, member: "sut")

        XCTAssertEqual(
            sut.debugDescription,
            "MockImplementationDescriptionTests.sut"
        )
    }
}
