//
//  MockedSubscriptTypeTests.swift
//
//  Copyright © 2026 Fetch.
//

import SwiftSyntax
import Testing
@testable import MockingMacros

struct MockedSubscriptTypeTests {

    // MARK: Typealiases

    typealias SUT = MockedSubscriptType

    // MARK: Init With Argument Tests

    @Test("Initializes as .readOnly from a valid argument.")
    func initReadOnly() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "subscriptType",
                base: nil,
                name: "readOnly"
            )
        )

        #expect(sut == .readOnly)
    }

    @Test("Initializes as .readWrite from a valid argument.")
    func initReadWrite() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "subscriptType",
                base: nil,
                name: "readWrite"
            )
        )

        #expect(sut == .readWrite)
    }

    @Test("Throws when initialized from an argument with an unknown name.")
    func initThrowsForUnknownName() {
        #expect(throws: SUT.ParsingError.unableToParseSubscriptType) {
            try SUT(
                argument: .macroArgumentSyntax(
                    label: "subscriptType",
                    base: nil,
                    name: "invalid"
                )
            )
        }
    }

    @Test("Throws when initialized from an argument that is not a member access expression.")
    func initThrowsForNonMemberAccessExpression() {
        #expect(throws: SUT.ParsingError.unableToParseSubscriptType) {
            try SUT(
                argument: LabeledExprSyntax(
                    label: .identifier("subscriptType"),
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
