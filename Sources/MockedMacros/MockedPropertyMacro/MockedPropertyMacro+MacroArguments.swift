//
//  MockedPropertyMacro+MacroArguments.swift
//  MockedMacros
//
//  Created by Gray Campbell on 1/17/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedPropertyMacro {

    /// Arguments provided to `@MockedProperty`.
    struct MacroArguments {

        // MARK: Properties

        /// The type of property to which the macro is attached.
        let propertyType: MockedPropertyType

        /// The name of the mock.
        let mockName: String

        /// A Boolean value indicating whether the mock is an actor.
        let isMockAnActor: Bool

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

            guard let propertyTypeArgument = argument(0) else {
                throw MacroError.unableToParsePropertyTypeArgument
            }

            self.propertyType = try MockedPropertyType(argument: propertyTypeArgument)

            guard
                let mockName = argument(1)?
                    .expression
                    .as(StringLiteralExprSyntax.self)?
                    .representedLiteralValue
            else {
                throw MacroError.unableToParseMockNameArgument
            }

            self.mockName = mockName

            guard
                let isMockAnActorTokenKind = argument(2)?
                    .expression
                    .as(BooleanLiteralExprSyntax.self)?
                    .literal
                    .tokenKind
            else {
                throw MacroError.unableToParseIsMockAnActorArgument
            }

            self.isMockAnActor = isMockAnActorTokenKind == .keyword(.true)
        }
    }
}
