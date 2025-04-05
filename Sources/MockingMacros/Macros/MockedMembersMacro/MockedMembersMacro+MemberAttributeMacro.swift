//
//  MockedMembersMacro+MemberAttributeMacro.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
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
        let members: MemberBlockItemListSyntax
        let mockName: TokenSyntax

        if let classDeclaration = declaration.as(ClassDeclSyntax.self) {
            members = classDeclaration.memberBlock.members
            mockName = classDeclaration.name.trimmed
        } else if let actorDeclaration = declaration.as(ActorDeclSyntax.self) {
            members = actorDeclaration.memberBlock.members
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
                mockMembers: members,
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
        [
            AttributeSyntax(
                atSign: .atSignToken(),
                attributeName: IdentifierTypeSyntax(name: "_MockedProperty"),
                leftParen: .leftParenToken(),
                arguments: .argumentList(
                    try LabeledExprListSyntax {
                        self.propertyTypeArgument(
                            expression: try self.propertyTypeArgumentExpression(
                                from: propertyDeclaration
                            )
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

    // MARK: Property Type Argument Expression

    /// Returns the `propertyType` argument's expression, parsed from the
    /// attributes of the provided `propertyDeclaration`.
    ///
    /// - Parameter propertyDeclaration: The property declaration from which to
    ///   parse the `propertyType` argument's expression.
    /// - Throws: An error if the `propertyType` argument's expression could not
    ///   be parsed from the attributes of the provided `propertyDeclaration`.
    /// - Returns: The `propertyType` argument's expression, parsed from the
    ///   attributes of the provided `propertyDeclaration`.
    private static func propertyTypeArgumentExpression(
        from propertyDeclaration: VariableDeclSyntax
    ) throws -> ExprSyntax {
        var propertyTypeArgumentExpression: ExprSyntax?

        for attribute in propertyDeclaration.attributes {
            guard
                case let .attribute(attribute) = attribute,
                let attributeName = attribute.attributeName.as(
                    IdentifierTypeSyntax.self
                ),
                attributeName.name.tokenKind == .identifier("MockableProperty")
            else {
                continue
            }

            guard
                case let .argumentList(arguments) = attribute.arguments,
                let propertyTypeArgument = arguments.first
            else {
                throw MacroError.unableToDeterminePropertyType
            }

            _ = try MockedPropertyType(argument: propertyTypeArgument)

            propertyTypeArgumentExpression = propertyTypeArgument.expression
            break
        }

        guard let propertyTypeArgumentExpression else {
            throw MacroError.unableToDeterminePropertyType
        }

        return propertyTypeArgumentExpression
    }

    // MARK: Method Declaration Attributes

    /// Returns attributes to add to the provided `methodDeclaration`.
    ///
    /// - Parameters:
    ///   - methodDeclaration: A method declaration.
    ///   - mockName: The name of the mock of which the method is a member.
    ///   - mockMembers: The members of the mock of which the method is a
    ///     member.
    ///   - isMockAnActor: A Boolean value indicating whether the mock, of which
    ///     the method is a member, is an actor.
    /// - Returns: Attributes to add to the provided `methodDeclaration`.
    private static func attributes(
        for methodDeclaration: FunctionDeclSyntax,
        mockName: TokenSyntax,
        mockMembers: MemberBlockItemListSyntax,
        isMockAnActor: Bool
    ) -> [AttributeSyntax] {
        [
            AttributeSyntax(
                atSign: .atSignToken(),
                attributeName: IdentifierTypeSyntax(name: "_MockedMethod"),
                leftParen: .leftParenToken(),
                arguments: .argumentList(
                    LabeledExprListSyntax {
                        self.mockNameArgument(mockName: mockName)
                        self.isMockAnActorArgument(
                            isMockAnActor: isMockAnActor,
                            trailingComma: .commaToken()
                        )
                        self.mockMethodNameArgument(
                            mockMethodName: self.mockMethodName(
                                for: methodDeclaration,
                                mockMembers: mockMembers
                            )
                        )
                    }
                ),
                rightParen: .rightParenToken(),
                trailingTrivia: .newline
            )
        ]
    }

    // MARK: Mock Method Name

    /// Returns a mock method name for the provided `methodDeclaration`.
    ///
    /// - Parameters:
    ///   - methodDeclaration: A method declaration.
    ///   - mockMembers: The members of the mock of which the method is a
    ///     member.
    /// - Returns: A mock method name for the provided `methodDeclaration`.
    private static func mockMethodName(
        for methodDeclaration: FunctionDeclSyntax,
        mockMembers: MemberBlockItemListSyntax
    ) -> String {
        if let explicitMockMethodName = self.explicitMockMethodName(
            for: methodDeclaration
        ) {
            return explicitMockMethodName
        }

        let mockMethodNameComponents = MockMethodNameComponents(
            methodDeclaration: methodDeclaration
        )
        var methodOverloadsNameComponents = self.nameComponentsForMethodOverloads(
            of: methodDeclaration,
            with: mockMethodNameComponents,
            in: mockMembers
        )

        var mockMethodName = methodDeclaration.name.trimmed.text

        guard !methodOverloadsNameComponents.isEmpty else {
            return mockMethodName
        }

        var index: Int = .zero
        var hasMockMethodNameConflict = true

        while hasMockMethodNameConflict {
            index += 1
            mockMethodName = mockMethodNameComponents.name(to: index)
            methodOverloadsNameComponents.removeAll { methodOverloadNameComponents in
                methodOverloadNameComponents.name(to: index) != mockMethodName
            }
            hasMockMethodNameConflict = !methodOverloadsNameComponents.isEmpty
        }

        return mockMethodName
    }

    /// Returns an array of `MockMethodNameComponents` for the method overloads
    /// of the provided `methodDeclaration` parsed from the provided `members`.
    ///
    /// - Parameters:
    ///   - methodDeclaration: A method declaration.
    ///   - mockMethodNameComponents: The `MockMethodNameComponents` for the
    ///     provided `methodDeclaration`.
    ///   - members: The members from which to identify method overloads of the
    ///     provided `methodDeclaration`.
    /// - Returns: An array of `MockMethodNameComponents` for the method
    ///   overloads of the provided `methodDeclaration` parsed from the provided
    ///   `members`.
    private static func nameComponentsForMethodOverloads(
        of methodDeclaration: FunctionDeclSyntax,
        with mockMethodNameComponents: MockMethodNameComponents,
        in members: MemberBlockItemListSyntax
    ) -> [MockMethodNameComponents] {
        let methodDeclarationName = methodDeclaration.name.trimmed.text

        return members.compactMap { member in
            guard
                let peerMethodDeclaration = member.decl.as(FunctionDeclSyntax.self),
                peerMethodDeclaration.name.trimmed.text == methodDeclarationName,
                self.explicitMockMethodName(for: peerMethodDeclaration) == nil
            else {
                return nil
            }

            let peerMockMethodNameComponents = MockMethodNameComponents(
                methodDeclaration: peerMethodDeclaration
            )

            guard
                peerMockMethodNameComponents.fullName != mockMethodNameComponents.fullName
            else {
                return nil
            }

            return peerMockMethodNameComponents
        }
    }

    /// Returns the explicit `mockMethodName` parsed from the provided
    /// `methodDeclaration`'s `@MockableMethod` attribute if it exists,
    /// otherwise `nil`.
    ///
    /// - Parameter methodDeclaration: The method declaration from which to
    ///   parse the explicit `mockMethodName`.
    /// - Returns: The explicit `mockMethodName` parsed from the provided
    ///   `methodDeclaration`'s `@MockableMethod` attribute if it exists,
    ///   otherwise `nil`.
    private static func explicitMockMethodName(
        for methodDeclaration: FunctionDeclSyntax
    ) -> String? {
        var explicitMockMethodName: String?

        for attribute in methodDeclaration.attributes {
            guard
                case let .attribute(attribute) = attribute,
                let attributeName = attribute.attributeName.as(
                    IdentifierTypeSyntax.self
                ),
                attributeName.name.tokenKind == .identifier("MockableMethod")
            else {
                continue
            }

            guard
                case let .argumentList(arguments) = attribute.arguments,
                let mockMethodNameArgumentExpression = arguments.first?.expression.as(
                    StringLiteralExprSyntax.self
                )
            else {
                break
            }

            explicitMockMethodName = mockMethodNameArgumentExpression.representedLiteralValue
            break
        }

        return explicitMockMethodName
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
    /// - Parameters:
    ///   - isMockAnActor: The Boolean value to use in the argument.
    ///   - trailingComma: The trailing comma to append to the argument. The
    ///     default value is `nil`.
    /// - Returns: An `isMockAnActor` argument with the provided `isMockAnActor`
    ///   Boolean value.
    private static func isMockAnActorArgument(
        isMockAnActor: Bool,
        trailingComma: TokenSyntax? = nil
    ) -> LabeledExprSyntax {
        LabeledExprSyntax(
            leadingTrivia: .newline.appending(.tab),
            label: "isMockAnActor",
            colon: .colonToken(),
            expression: BooleanLiteralExprSyntax(isMockAnActor),
            trailingComma: trailingComma,
            trailingTrivia: .newline
        )
    }

    /// Returns a `mockMethodName` argument with the provided `mockMethodName`.
    ///
    /// - Parameter mockMethodName: The mock method name to use in the argument.
    /// - Returns: A `mockMethodName` argument with the provided
    ///   `mockMethodName`.
    private static func mockMethodNameArgument(
        mockMethodName: String
    ) -> LabeledExprSyntax {
        LabeledExprSyntax(
            leadingTrivia: .tab,
            label: "mockMethodName",
            colon: .colonToken(),
            expression: StringLiteralExprSyntax(
                openingQuote: .stringQuoteToken(),
                content: mockMethodName,
                closingQuote: .stringQuoteToken()
            ),
            trailingTrivia: .newline
        )
    }
}
