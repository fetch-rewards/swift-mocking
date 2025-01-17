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
        let mockName: TokenSyntax

        /// A Boolean value indicating whether the mock is an actor.
        let isMockAnActor: Bool

        // MARK: Initializers

        /// Creates macro arguments parsed from the provided `node`.
        ///
        /// - Parameter node: The node representing the macro.
        init(node: AttributeSyntax) throws {
            let arguments = node.arguments?.as(LabeledExprListSyntax.self)

            guard
                let mockName = arguments?
                    .first?
                    .expression
                    .as(StringLiteralExprSyntax.self)?
                    .segments
                    .first?
                    .as(StringSegmentSyntax.self)?
                    .content
            else {
                throw MacroError.unableToParseMockNameArgument
            }

            guard
                let isMockAnActorTokenKind = arguments?
                    .last?
                    .expression
                    .as(BooleanLiteralExprSyntax.self)?
                    .literal
                    .tokenKind
            else {
                throw MacroError.unableToParseIsMockAnActorArgument
            }

            self.mockName = mockName
            self.isMockAnActor = isMockAnActorTokenKind == .keyword(.true)
        }
    }
}
