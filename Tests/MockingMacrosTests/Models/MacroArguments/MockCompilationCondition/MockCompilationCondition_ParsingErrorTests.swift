//
//  MockCompilationCondition_ParsingErrorTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import MockingMacros

struct MockCompilationCondition_ParsingErrorTests {

    // MARK: Typealiases

    typealias SUT = MockCompilationCondition.ParsingError

    // MARK: Description Tests

    @Test(arguments: SUT.allCases)
    func description(sut: SUT) {
        let expectedDescription = switch sut {
        case .unableToParseCompilationCondition:
            "Unable to parse compilation condition."
        }

        #expect(sut.description == expectedDescription)
    }
}
