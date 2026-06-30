//
//  MockedSubscriptMacro+MacroArguments.swift
//
//  Copyright © 2026 Fetch.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedSubscriptMacro {

    /// Arguments provided to `@_MockedSubscript`.
    struct MacroArguments {

        // MARK: Properties

        /// The type of subscript to which the macro is attached.
        let subscriptType: MockedSubscriptType

        /// The name of the mock.
        let mockName: String

        /// A Boolean value indicating whether the mock is an actor.
        let isMockAnActor: Bool

        /// The disambiguated name to use for the mock's backing and exposed
        /// subscript properties.
        let mockSubscriptName: String

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

            let subscriptTypeArgument = argument(0)
            let mockName = argument(1)?
                .expression
                .as(StringLiteralExprSyntax.self)?
                .representedLiteralValue
            let isMockAnActorTokenKind = argument(2)?
                .expression
                .as(BooleanLiteralExprSyntax.self)?
                .literal
                .tokenKind
            let mockSubscriptName = argument(3)?
                .expression
                .as(StringLiteralExprSyntax.self)?
                .representedLiteralValue

            guard let subscriptTypeArgument else {
                throw MacroError.unableToParseSubscriptTypeArgument
            }

            guard let mockName else {
                throw MacroError.unableToParseMockNameArgument
            }

            guard let isMockAnActorTokenKind else {
                throw MacroError.unableToParseIsMockAnActorArgument
            }

            guard let mockSubscriptName else {
                throw MacroError.unableToParseMockSubscriptNameArgument
            }

            self.subscriptType = try MockedSubscriptType(argument: subscriptTypeArgument)
            self.mockName = mockName
            self.isMockAnActor = isMockAnActorTokenKind == .keyword(.true)
            self.mockSubscriptName = mockSubscriptName
        }
    }
}
