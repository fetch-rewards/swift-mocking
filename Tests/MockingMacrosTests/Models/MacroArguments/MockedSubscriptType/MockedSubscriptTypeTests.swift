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

    @Test("Initializes as .readOnly(.async, nil) from a factory argument with an async specifier.")
    func initReadOnlyWithAsyncSpecifier() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "subscriptType",
                name: "readOnly",
                arguments: [
                    .macroArgumentSyntax(label: "", base: nil, name: "async"),
                ]
            )
        )

        #expect(sut == .readOnly(.async, nil))
    }

    @Test("Initializes as .readOnly(nil, .throws) from a factory argument with a throws specifier.")
    func initReadOnlyWithThrowsSpecifier() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "subscriptType",
                name: "readOnly",
                arguments: [
                    .macroArgumentSyntax(label: "", base: nil, name: "throws"),
                ]
            )
        )

        #expect(sut == .readOnly(nil, .throws))
    }

    @Test("Initializes as .readOnly(.async, .throws) from a factory argument with both specifiers.")
    func initReadOnlyWithAsyncAndThrowsSpecifiers() throws {
        let sut = try SUT(
            argument: .macroArgumentSyntax(
                label: "subscriptType",
                name: "readOnly",
                arguments: [
                    .macroArgumentSyntax(label: "", base: nil, name: "async"),
                    .macroArgumentSyntax(label: "", base: nil, name: "throws"),
                ]
            )
        )

        #expect(sut == .readOnly(.async, .throws))
    }

    // MARK: Getter Async Specifier Tests

    @Test("Returns the async specifier for a .readOnly case.")
    func getterAsyncSpecifierForReadOnly() {
        #expect(SUT.readOnly(.async, nil).getterAsyncSpecifier == .async)
    }

    @Test("Returns nil for the async specifier of a .readWrite case.")
    func getterAsyncSpecifierForReadWrite() {
        #expect(SUT.readWrite.getterAsyncSpecifier == nil)
    }

    @Test("Returns nil for the async specifier of a .readOnly case without an async specifier.")
    func getterAsyncSpecifierAbsent() {
        #expect(SUT.readOnly.getterAsyncSpecifier == nil)
    }

    // MARK: Getter Throws Specifier Tests

    @Test("Returns the throws specifier for a .readOnly case.")
    func getterThrowsSpecifierForReadOnly() {
        #expect(SUT.readOnly(nil, .throws).getterThrowsSpecifier == .throws)
    }

    @Test("Returns nil for the throws specifier of a .readWrite case.")
    func getterThrowsSpecifierForReadWrite() {
        #expect(SUT.readWrite.getterThrowsSpecifier == nil)
    }

    @Test("Returns nil for the throws specifier of a .readOnly case without a throws specifier.")
    func getterThrowsSpecifierAbsent() {
        #expect(SUT.readOnly.getterThrowsSpecifier == nil)
    }

    // MARK: Parsing Error Tests

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
