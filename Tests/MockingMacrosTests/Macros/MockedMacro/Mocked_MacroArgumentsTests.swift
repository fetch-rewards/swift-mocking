//
//  Mocked_MacroArgumentsTests.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax
import Testing
@testable import MockingMacros

struct Mocked_MacroArgumentsTests {

    // MARK: Argument parsing tests

    @Test("Doesn't parse values from unknown argument labels.")
    func unknownLabel() {
        let node = node(
            arguments: [
                .macroArgumentSyntax(
                    label: "sendability",
                    base: nil,
                    name: "unchecked"
                ),
            ]
        )
        let arguments = MockedMacro.MacroArguments(node: node)

        #expect(arguments.sendableConformance == .checked)
    }

    @Test("Sets default values when no arguments received.")
    func defaultValues() {
        let node = node(arguments: [])
        let arguments = MockedMacro.MacroArguments(node: node)

        #expect(arguments.compilationCondition == .swiftMockingEnabled)
        #expect(arguments.sendableConformance == .checked)
    }

    @Test("Partial argument lists use default values for missing arguments.")
    func partialArgumentList() {
        let node = node(
            arguments: [
                .macroArgumentSyntax(
                    label: "sendableConformance",
                    base: nil,
                    name: "unchecked"
                ),
            ]
        )
        let arguments = MockedMacro.MacroArguments(node: node)

        #expect(arguments.compilationCondition == .swiftMockingEnabled)
        #expect(arguments.sendableConformance == .unchecked)
    }

    // MARK: Helper functions

    private func node(arguments: [LabeledExprSyntax]) -> AttributeSyntax {
        AttributeSyntax(
            atSign: .atSignToken(),
            attributeName: IdentifierTypeSyntax(name: "Mocked"),
            arguments: .init(LabeledExprListSyntax(arguments))
        )
    }
}
