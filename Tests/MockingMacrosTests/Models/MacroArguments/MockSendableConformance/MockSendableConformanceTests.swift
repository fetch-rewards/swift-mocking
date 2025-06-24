//
//  MockSendableConformanceTests.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax
import Testing
@testable import MockingMacros

struct MockSendableConformanceTests {

    // MARK: Typealiases

    typealias SUT = MockSendableConformance

    // MARK: Init With Argument Tests

    @Test("Initializes as .checked from a valid argument with base.")
    func initCheckedFromArgumentWithBase() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "sendableConformance",
                base: "MockSendableConformance",
                name: "checked"
            )
        )

        #expect(sut == .checked)
    }

    @Test("Initializes as .checked from a valid argument without base.")
    func initCheckedFromArgumentWithoutBase() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "sendableConformance",
                base: nil,
                name: "checked"
            )
        )

        #expect(sut == .checked)
    }

    @Test("Initializes as .unchecked from a valid argument with base.")
    func initUncheckedFromArgumentWithBase() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "sendableConformance",
                base: "MockSendableConformance",
                name: "unchecked"
            )
        )

        #expect(sut == .unchecked)
    }

    @Test("Initializes as .unchecked from a valid argument without base.")
    func initUncheckedFromArgumentWithoutBase() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "sendableConformance",
                base: nil,
                name: "unchecked"
            )
        )

        #expect(sut == .unchecked)
    }

    @Test("Initializes as nil from an invalid argument with base.")
    func initNilFromInvalidArgumentWithBase() {
        #expect(throws: SUT.ParsingError.unableToParseSendableConformance) {
            try SUT(
                argument: .macroArgumentSyntax(
                    label: "sendableConformance",
                    base: "MockSendableConformance",
                    name: "invalid"
                )
            )
        }
    }

    @Test("Initializes as nil from an invalid argument without base.")
    func initNilFromInvalidArgumentWithoutBase() {
        #expect(throws: SUT.ParsingError.unableToParseSendableConformance) {
            try SUT(
                argument: .macroArgumentSyntax(
                    label: "sendableConformance",
                    base: nil,
                    name: "invalid"
                )
            )
        }
    }

    @Test("Initializes as nil from an argument with an invalid name token.")
    func initNilFromNamelessArgument() {
        #expect(throws: SUT.ParsingError.unableToParseSendableConformance) {
            try SUT(
                argument: LabeledExprSyntax(
                    label: .identifier("sendableConformance"),
                    colon: .colonToken(),
                    expression: MemberAccessExprSyntax(
                        period: .periodToken(),
                        declName: DeclReferenceExprSyntax(baseName: .commaToken())
                    )
                )
            )
        }
    }
}
