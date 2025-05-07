//
//  MockedMacro+MacroArguments.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedMacro {

    /// Arguments provided to `@Mocked`.
    struct MacroArguments {

        // MARK: Properties

        /// The compilation condition with which to wrap the generated mock.
        let compilationCondition: MockCompilationCondition

        /// The `Sendable` conformance to apply to the generated mock.
        let sendableConformance: MockSendableConformance

        // MARK: Initializers

        /// Creates macro arguments parsed from the provided `node`.
        ///
        /// - Parameter node: The node representing the macro.
        init(node: AttributeSyntax) {
            let arguments = node.arguments?.as(LabeledExprListSyntax.self)

            func argumentValue<ArgumentValue: MacroArgumentValue>(
                named name: String,
                default: ArgumentValue
            ) -> ArgumentValue {
                guard
                    let arguments,
                    let argument = arguments.first(where: { argument in
                        argument.label?.text == name
                    }),
                    let value = ArgumentValue(argument: argument)
                else {
                    return `default`
                }

                return value
            }

            self.compilationCondition = argumentValue(
                named: "compilationCondition",
                default: .swiftMockingEnabled
            )

            self.sendableConformance = argumentValue(
                named: "sendableConformance",
                default: .checked
            )
        }
    }
}
