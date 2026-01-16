//
//  MockSendableConformance_ParsingErrorTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import MockingMacros

struct MockSendableConformance_ParsingErrorTests {

    // MARK: Typealiases

    typealias SUT = MockSendableConformance.ParsingError

    // MARK: Description Tests

    @Test(arguments: SUT.allCases)
    func description(sut: SUT) {
        let expectedDescription = switch sut {
        case .unableToParseSendableConformance:
            "Unable to parse Sendable conformance."
        }

        #expect(sut.description == expectedDescription)
    }
}
