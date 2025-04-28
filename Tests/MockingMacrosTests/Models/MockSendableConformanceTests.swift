//
//  MockSendableConformanceTests.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax
import Testing
@testable import MockingMacros

struct MockSendableConformanceTests {

    // MARK: Init from argument tests

    @Test("Initializes as .checked from a valid checked argument.")
    func initCheckedFromArgument() {
        let sendableConformance = MockSendableConformance(
            argument: .macroArgumentSyntax(
                label: "sendableConformance",
                base: nil,
                name: "checked"
            )
        )
        #expect(sendableConformance == .checked)
    }

    @Test("Initializes as .unchecked from a valid unchecked argument.")
    func initUncheckedFromArgument() {
        let sendableConformance = MockSendableConformance(
            argument: .macroArgumentSyntax(
                label: "sendableConformance",
                base: nil,
                name: "unchecked"
            )
        )
        #expect(sendableConformance == .unchecked)
    }

    @Test("Initializes as nil from an unrecognized argument.")
    func initNilFromArgument() {
        let sendableConformance = MockSendableConformance(
            argument: .macroArgumentSyntax(
                label: "sendableConformance",
                base: nil,
                name: "unrecognized"
            )
        )
        #expect(sendableConformance == nil)
    }

    @Test("Initializes from argument when base is included.")
    func initFromArgumentWithBase() {
        let sendableConformance = MockSendableConformance(
            argument: .macroArgumentSyntax(
                label: "sendableConformance",
                base: "MockSendableConformance",
                name: "checked"
            )
        )
        #expect(sendableConformance == .checked)
    }
}
