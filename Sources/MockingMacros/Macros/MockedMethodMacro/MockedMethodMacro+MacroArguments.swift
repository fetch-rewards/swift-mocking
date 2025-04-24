//
//  MockedMethodMacro+MacroArguments.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedMethodMacro {

    /// Arguments provided to `@_MockedMethod`.
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

            let mockName = argument(0)?
                .expression
                .as(StringLiteralExprSyntax.self)?
                .representedLiteralValue
            let isMockAnActorTokenKind = argument(1)?
                .expression
                .as(BooleanLiteralExprSyntax.self)?
                .literal
                .tokenKind
            let mockMethodName = argument(2)?
                .expression
                .as(StringLiteralExprSyntax.self)?
                .representedLiteralValue

            guard let mockName else {
                throw MacroError.unableToParseMockNameArgument
            }

            guard let isMockAnActorTokenKind else {
                throw MacroError.unableToParseIsMockAnActorArgument
            }

            guard let mockMethodName else {
                throw MacroError.unableToParseMockMethodName
            }

            self.mockName = mockName
            self.isMockAnActor = isMockAnActorTokenKind == .keyword(.true)
            self.mockMethodName = mockMethodName
        }
    }
}
