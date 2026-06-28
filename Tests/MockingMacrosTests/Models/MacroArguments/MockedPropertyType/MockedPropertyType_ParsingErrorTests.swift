//
//  MockedPropertyType_ParsingErrorTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import MockingMacros

struct MockedPropertyType_ParsingErrorTests {

    // MARK: Typealiases

    typealias SUT = MockedPropertyType.ParsingError

    // MARK: Description Tests

    @Test(arguments: SUT.allCases)
    func description(sut: SUT) {
        let expectedDescription = switch sut {
        case .unableToParsePropertyType:
            "Unable to parse property type."
        case .unableToParseAsyncEffectSpecifier:
            "Unable to parse async effect specifier."
        case .unableToParseThrowsEffectSpecifier:
            "Unable to parse throws effect specifier."
        }

        #expect(sut.description == expectedDescription)
    }
}
