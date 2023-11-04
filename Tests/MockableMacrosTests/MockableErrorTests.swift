//
//  MockableErrorTests.swift
//  MockableMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockableMacros)
import MockableMacros
import XCTest

final class MockableErrorTests: XCTestCase {

    // MARK: Description Tests

    func testDescription() {
        for error in MockableError.allCases {
            let expectedDescription =
                switch error {
                case .canOnlyBeAppliedToProtocols:
                    "@Mockable can only be applied to protocols"
                }

            XCTAssertEqual(error.description, expectedDescription)
        }
    }
}
#endif
