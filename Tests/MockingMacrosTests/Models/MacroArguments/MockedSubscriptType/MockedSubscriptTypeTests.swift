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

    @Test
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

    @Test
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

    @Test
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

    @Test
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

    @Test
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

    @Test
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

    @Test
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

    // MARK: Getter Async Specifier Tests

    @Test
    func getterAsyncSpecifierForReadOnly() {
        #expect(SUT.readOnly(.async, nil).getterAsyncSpecifier == .async)
    }

    @Test
    func getterAsyncSpecifierForReadWrite() {
        #expect(SUT.readWrite.getterAsyncSpecifier == nil)
    }

    @Test
    func getterAsyncSpecifierAbsent() {
        #expect(SUT.readOnly.getterAsyncSpecifier == nil)
    }

    // MARK: Getter Throws Specifier Tests

    @Test
    func getterThrowsSpecifierForReadOnly() {
        #expect(SUT.readOnly(nil, .throws).getterThrowsSpecifier == .throws)
    }

    @Test
    func getterThrowsSpecifierForReadWrite() {
        #expect(SUT.readWrite.getterThrowsSpecifier == nil)
    }

    @Test
    func getterThrowsSpecifierAbsent() {
        #expect(SUT.readOnly.getterThrowsSpecifier == nil)
    }

}
