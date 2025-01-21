//
//  MockedMembersMacro+MemberAttributeMacro.swift
//  MockedMacros
//
//  Created by Gray Campbell on 1/15/25.
//

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedMembersMacro: MemberAttributeMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        let mockName: TokenSyntax

        if let classDeclaration = declaration.as(ClassDeclSyntax.self) {
            mockName = classDeclaration.name.trimmed
        } else if let actorDeclaration = declaration.as(ActorDeclSyntax.self) {
            mockName = actorDeclaration.name.trimmed
        } else {
            throw MacroError.canOnlyBeAppliedToClassesAndActors
        }

        let isMockAnActor = declaration.introducer.tokenKind == .keyword(.actor)

        if let propertyDeclaration = member.as(VariableDeclSyntax.self) {
            return try self.attributes(
                for: propertyDeclaration,
                mockName: mockName,
                isMockAnActor: isMockAnActor
            )
        } else if let methodDeclaration = member.as(FunctionDeclSyntax.self) {
            return self.attributes(
                for: methodDeclaration,
                mockName: mockName,
                isMockAnActor: isMockAnActor
            )
        } else {
            return []
        }
    }

    // MARK: Property Declaration Attributes

    /// Returns attributes to add to the provided `propertyDeclaration`.
    ///
    /// - Parameters:
    ///   - propertyDeclaration: A property declaration.
    ///   - mockName: The name of the mock of which the property is a member.
    ///   - isMockAnActor: A Boolean value indicating whether the mock, of which
    ///     the property is a member, is an actor.
    /// - Returns: Attributes to add to the provided `propertyDeclaration`.
    private static func attributes(
        for propertyDeclaration: VariableDeclSyntax,
        mockName: TokenSyntax,
        isMockAnActor: Bool
    ) throws -> [AttributeSyntax] {
        var propertyTypeArgumentExpression: ExprSyntax?

        for attribute in propertyDeclaration.attributes {
            guard
                case let .attribute(attribute) = attribute,
                let attributeName = attribute.attributeName.as(
                    IdentifierTypeSyntax.self
                ),
                attributeName.name.tokenKind == .identifier("MockableProperty"),
                case let .argumentList(arguments) = attribute.arguments,
                let propertyTypeArgument = arguments.first
            else {
                continue
            }

            _ = try MockedPropertyType(argument: propertyTypeArgument)

            propertyTypeArgumentExpression = propertyTypeArgument.expression
            break
        }

        guard let propertyTypeArgumentExpression else {
            return []
        }

        return [
            AttributeSyntax(
                atSign: .atSignToken(),
                attributeName: IdentifierTypeSyntax(name: "MockedProperty"),
                leftParen: .leftParenToken(),
                arguments: .argumentList(
                    LabeledExprListSyntax {
                        self.propertyTypeArgument(
                            expression: propertyTypeArgumentExpression
                        )
                        self.mockNameArgument(mockName: mockName)
                        self.isMockAnActorArgument(isMockAnActor: isMockAnActor)
                    }
                ),
                rightParen: .rightParenToken(),
                trailingTrivia: .newline
            )
        ]
    }

    // MARK: Method Declaration Attributes

    /// Returns attributes to add to the provided `methodDeclaration`.
    ///
    /// - Parameters:
    ///   - methodDeclaration: A method declaration.
    ///   - mockName: The name of the mock of which the method is a member.
    ///   - isMockAnActor: A Boolean value indicating whether the mock, of which
    ///     the method is a member, is an actor.
    /// - Returns: Attributes to add to the provided `methodDeclaration`.
    private static func attributes(
        for methodDeclaration: FunctionDeclSyntax,
        mockName: TokenSyntax,
        isMockAnActor: Bool
    ) -> [AttributeSyntax] {
        [
            AttributeSyntax(
                atSign: .atSignToken(),
                attributeName: IdentifierTypeSyntax(name: "MockedMethod"),
                leftParen: .leftParenToken(),
                arguments: .argumentList(
                    LabeledExprListSyntax {
                        self.mockNameArgument(mockName: mockName)
                        self.isMockAnActorArgument(isMockAnActor: isMockAnActor)
                    }
                ),
                rightParen: .rightParenToken(),
                trailingTrivia: .newline
            )
        ]
    }

    // MARK: Macro Arguments

    /// Returns a `propertyType` argument with the provided `expression`.
    ///
    /// - Parameter expression: The expression to use in the argument.
    /// - Returns: A `propertyType` argument with the provided `expression`.
    private static func propertyTypeArgument(
        expression: some ExprSyntaxProtocol
    ) -> LabeledExprSyntax {
        LabeledExprSyntax(
            leadingTrivia: .newline.appending(.tab),
            expression: expression
        )
    }

    /// Returns a `mockName` argument with the provided `mockName`.
    ///
    /// - Parameter mockName: The mock name to use in the argument.
    /// - Returns: A `mockName` argument with the provided `mockName`.
    private static func mockNameArgument(
        mockName: TokenSyntax
    ) -> LabeledExprSyntax {
        LabeledExprSyntax(
            leadingTrivia: .newline.appending(.tab),
            label: "mockName",
            colon: .colonToken(),
            expression: StringLiteralExprSyntax(
                openingQuote: .stringQuoteToken(),
                content: mockName.text,
                closingQuote: .stringQuoteToken()
            ),
            trailingComma: .commaToken()
        )
    }

    /// Returns an `isMockAnActor` argument with the provided `isMockAnActor`
    /// Boolean value.
    ///
    /// - Parameter isMockAnActor: The Boolean value to use in the argument.
    /// - Returns: An `isMockAnActor` argument with the provided `isMockAnActor`
    ///   Boolean value.
    private static func isMockAnActorArgument(
        isMockAnActor: Bool
    ) -> LabeledExprSyntax {
        LabeledExprSyntax(
            leadingTrivia: .newline.appending(.tab),
            label: "isMockAnActor",
            colon: .colonToken(),
            expression: BooleanLiteralExprSyntax(isMockAnActor),
            trailingTrivia: .newline
        )
    }
}
