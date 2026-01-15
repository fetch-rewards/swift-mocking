//
//  MockCompilationConditionTests.swift
//
//  Copyright © 2026 Fetch.
//

import SwiftSyntax
import Testing
@testable import MockingMacros

struct MockCompilationConditionTests {

    // MARK: Typealiases

    typealias SUT = MockCompilationCondition

    // MARK: Raw Value Tests

    @Test(
        arguments: [
            SUT.none,
            SUT.debug,
            SUT.swiftMockingEnabled,
            SUT.custom("!RELEASE"),
        ]
    )
    func rawValue(sut: SUT) {
        let expectedRawValue: String? = switch sut {
        case .none:
            nil
        case .debug:
            "DEBUG"
        case .swiftMockingEnabled:
            "SWIFT_MOCKING_ENABLED"
        case let .custom(condition):
            condition
        }

        #expect(sut.rawValue == expectedRawValue)
    }

    // MARK: Init With Raw Value Tests

    @Test
    func initWithRawValueNone() {
        let sut = SUT(rawValue: nil)

        guard case .none = sut else {
            Issue.record("Expected sut to be `.none`.")
            return
        }
    }

    @Test
    func initWithRawValueDebug() {
        let sut = SUT(rawValue: "DEBUG")

        guard case .debug = sut else {
            Issue.record("Expected sut to be `.debug`.")
            return
        }
    }

    @Test
    func initWithRawValueSwiftMockingEnabled() {
        let sut = SUT(rawValue: "SWIFT_MOCKING_ENABLED")

        guard case .swiftMockingEnabled = sut else {
            Issue.record("Expected sut to be `.swiftMockingEnabled`.")
            return
        }
    }

    @Test
    func initWithRawValueCustom() {
        let sut = SUT(rawValue: "!RELEASE")

        guard case .custom("!RELEASE") = sut else {
            Issue.record(#"Expected sut to be `.custom("!RELEASE")`."#)
            return
        }
    }

    // MARK: Init With Argument Tests

    @Test("Initializes as .none from a valid argument with base.")
    func initNoneFromArgumentWithBase() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "compilationCondition",
                base: "MockCompilationCondition",
                name: "none"
            )
        )

        #expect(sut == .none)
    }

    @Test("Initializes as .none from a valid argument without base.")
    func initNoneFromArgumentWithoutBase() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "compilationCondition",
                base: nil,
                name: "none"
            )
        )

        #expect(sut == .none)
    }

    @Test("Initializes as .debug from a valid argument with base.")
    func initDebugFromArgumentWithBase() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "compilationCondition",
                base: "MockCompilationCondition",
                name: "debug"
            )
        )

        #expect(sut == .debug)
    }

    @Test("Initializes as .debug from a valid argument without base.")
    func initDebugFromArgumentWithoutBase() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "compilationCondition",
                base: nil,
                name: "debug"
            )
        )

        #expect(sut == .debug)
    }

    @Test("Initializes as .swiftMockingEnabled from a valid argument with base.")
    func initSwiftMockingEnabledFromArgumentWithBase() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "compilationCondition",
                base: "MockCompilationCondition",
                name: "swiftMockingEnabled"
            )
        )

        #expect(sut == .swiftMockingEnabled)
    }

    @Test("Initializes as .swiftMockingEnabled from a valid argument without base.")
    func initSwiftMockingEnabledFromArgumentWithoutBase() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "compilationCondition",
                base: nil,
                name: "swiftMockingEnabled"
            )
        )

        #expect(sut == .swiftMockingEnabled)
    }

    @Test("Initializes as .custom from a valid argument with base.")
    func initCustomFromArgumentWithBase() throws {
        let sut = try SUT(
            argument: LabeledExprSyntax(
                label: "compilationCondition",
                colon: .colonToken(),
                expression: FunctionCallExprSyntax(
                    calledExpression: MemberAccessExprSyntax(
                        base: DeclReferenceExprSyntax(baseName: "MockCompilationCondition"),
                        period: .periodToken(),
                        declName: DeclReferenceExprSyntax(baseName: "custom")
                    ),
                    leftParen: .leftParenToken(),
                    arguments: LabeledExprListSyntax {
                        LabeledExprSyntax(
                            expression: StringLiteralExprSyntax(content: "!RELEASE")
                        )
                    },
                    rightParen: .rightParenToken()
                )
            )
        )

        #expect(sut == .custom("!RELEASE"))
    }

    @Test("Initializes as .custom from a valid argument without base.")
    func initCustomFromArgumentWithoutBase() throws {
        let sut = try SUT(
            argument: LabeledExprSyntax(
                label: "compilationCondition",
                colon: .colonToken(),
                expression: FunctionCallExprSyntax(
                    calledExpression: MemberAccessExprSyntax(
                        period: .periodToken(),
                        declName: DeclReferenceExprSyntax(baseName: "custom")
                    ),
                    leftParen: .leftParenToken(),
                    arguments: LabeledExprListSyntax {
                        LabeledExprSyntax(
                            expression: StringLiteralExprSyntax(content: "!RELEASE")
                        )
                    },
                    rightParen: .rightParenToken()
                )
            )
        )

        #expect(sut == .custom("!RELEASE"))
    }

    @Test("Initializes as nil from an invalid argument with base.")
    func initNilFromInvalidArgumentWithBase() {
        #expect(throws: SUT.ParsingError.unableToParseCompilationCondition) {
            try SUT(
                argument: .macroArgumentSyntax(
                    label: "compilationCondition",
                    base: "MockCompilationCondition",
                    name: "invalid"
                )
            )
        }
    }

    @Test("Initializes as nil from an invalid argument without base.")
    func initNilFromInvalidArgumentWithoutBase() {
        #expect(throws: SUT.ParsingError.unableToParseCompilationCondition) {
            try SUT(
                argument: .macroArgumentSyntax(
                    label: "compilationCondition",
                    base: nil,
                    name: "invalid"
                )
            )
        }
    }

    @Test("Initializes as nil from an argument with an invalid name token.")
    func initNilFromNamelessArgument() {
        #expect(throws: SUT.ParsingError.unableToParseCompilationCondition) {
            try SUT(
                argument: LabeledExprSyntax(
                    label: .identifier("compilationCondition"),
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
