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

        /// The sendable conformance to apply to the generated mock.
        let sendableConformance: MockSendableConformance

        // MARK: Initializers

        /// Creates macro arguments parsed from the provided `node`.
        ///
        /// - Parameter node: The node representing the macro.
        init(node: AttributeSyntax) {
            let arguments = node.arguments?.as(LabeledExprListSyntax.self)

            func argumentValue<A>(
                for argumentType: A.Type,
                default: A
            ) -> A where A: MacroArgument {
                guard let arguments else {
                    return `default`
                }
                for argument in arguments {
                    if let value = A(argument: argument) {
                        return value
                    }
                }
                return `default`
            }

            self.compilationCondition = argumentValue(
                for: MockCompilationCondition.self,
                default: .swiftMockingEnabled
            )

            self.sendableConformance = argumentValue(
                for: MockSendableConformance.self,
                default: .checked
            )
        }
    }
}
