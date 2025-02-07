//
//  MockedMethodMacro+MacroArguments.swift
//  MockedMacros
//
//  Created by Gray Campbell on 1/15/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedMethodMacro {

    /// Arguments provided to `@MockedMacro`.
    struct MacroArguments {

        // MARK: Properties

        /// The name of the mock.
        let mockName: String

        /// A Boolean value indicating whether the mock is an actor.
        let isMockAnActor: Bool

        /// The name to use for the mock method.
        let mockMethodName: String

        // MARK: Initializers

        /// Creates macro arguments parsed from the provided `node`.
        ///
        /// - Parameter node: The node representing the macro.
        init(node: AttributeSyntax) throws {
            guard
                let arguments = node.arguments?.as(LabeledExprListSyntax.self),
                arguments.count > .zero
            else {
                throw MacroError.noArguments
            }

            let argument: (Int) -> LabeledExprSyntax? = { index in
                let argumentIndex = arguments.index(at: index)

                return arguments.count > index ? arguments[argumentIndex] : nil
            }

            guard
                let mockName = argument(0)?
                    .expression
                    .as(StringLiteralExprSyntax.self)?
                    .representedLiteralValue
            else {
                throw MacroError.unableToParseMockNameArgument
            }

            self.mockName = mockName

            guard
                let isMockAnActorTokenKind = argument(1)?
                    .expression
                    .as(BooleanLiteralExprSyntax.self)?
                    .literal
                    .tokenKind
            else {
                throw MacroError.unableToParseIsMockAnActorArgument
            }

            self.isMockAnActor = isMockAnActorTokenKind == .keyword(.true)

            guard
                let mockMethodName = argument(2)?
                    .expression
                    .as(StringLiteralExprSyntax.self)?
                    .representedLiteralValue
            else {
                throw MacroError.unableToParseMockMethodName
            }

            self.mockMethodName = mockMethodName
        }
    }
}
