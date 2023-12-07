//
//  MockedErrorTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import MockedMacros
import XCTest

final class MockedErrorTests: XCTestCase {

    // MARK: Description Tests

    func testDescription() {
        for error in MockedError.allCases {
            let expectedDescription = switch error {
            case .canOnlyBeAppliedToProtocols:
                "@Mocked can only be applied to protocols"
            }

            XCTAssertEqual(error.description, expectedDescription)
        }
    }
}
#endif
