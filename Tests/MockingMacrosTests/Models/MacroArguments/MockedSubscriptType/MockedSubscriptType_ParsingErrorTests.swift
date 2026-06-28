//
//  MockedSubscriptType_ParsingErrorTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import MockingMacros

struct MockedSubscriptType_ParsingErrorTests {

    // MARK: Typealiases

    typealias SUT = MockedSubscriptType.ParsingError

    // MARK: Description Tests

    @Test(arguments: SUT.allCases)
    func description(sut: SUT) {
        let expectedDescription = switch sut {
        case .unableToParseSubscriptType:
            "Unable to parse subscript type."
        }

        #expect(sut.description == expectedDescription)
    }
}
