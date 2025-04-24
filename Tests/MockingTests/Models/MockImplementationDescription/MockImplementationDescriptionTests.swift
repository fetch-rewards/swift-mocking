//
//  MockImplementationDescriptionTests.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import XCTest
@testable import Mocking

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
