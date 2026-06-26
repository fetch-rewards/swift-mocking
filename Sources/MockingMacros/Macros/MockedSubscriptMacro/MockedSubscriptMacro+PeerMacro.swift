//
//  MockedSubscriptMacro+PeerMacro.swift
//
//  Copyright © 2026 Fetch.
//

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedSubscriptMacro: PeerMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let subscriptDeclaration = declaration.as(SubscriptDeclSyntax.self) else {
            throw MacroError.canOnlyBeAppliedToSubscriptDeclarations
        }

        let macroArguments = try MacroArguments(node: node)
        let overrideDeclarationType = self.overrideDeclarationType(
            from: subscriptDeclaration,
            subscriptType: macroArguments.subscriptType
        )
        let backingOverrideDeclaration = self.backingOverrideDeclaration(
            macroArguments: macroArguments,
            subscriptDeclaration: subscriptDeclaration,
            overrideDeclarationType: overrideDeclarationType
        )
        let exposedOverrideDeclaration = self.exposedOverrideDeclaration(
            macroArguments: macroArguments,
            subscriptDeclaration: subscriptDeclaration,
            overrideDeclarationType: overrideDeclarationType
        )

        return [
            DeclSyntax(backingOverrideDeclaration),
            DeclSyntax(exposedOverrideDeclaration),
        ]
    }

    // MARK: Override Declarations

    /// Returns a backing override declaration for the provided
    /// `subscriptDeclaration`.
    ///
    /// - Parameters:
    ///   - macroArguments: The arguments passed to the macro.
    ///   - subscriptDeclaration: The subscript declaration to which the macro
    ///     is attached.
    ///   - overrideDeclarationType: The type to apply to the backing override
    ///     declaration.
    /// - Returns: A backing override declaration.
    private static func backingOverrideDeclaration(
        macroArguments: MacroArguments,
        subscriptDeclaration: SubscriptDeclSyntax,
        overrideDeclarationType: IdentifierTypeSyntax
    ) -> VariableDeclSyntax {
        let name = macroArguments.mockSubscriptName
        let modifiers = self.overrideDeclarationModifiers(
            from: subscriptDeclaration.modifiers,
            with: AccessLevelSyntax.private,
            isMockAnActor: macroArguments.isMockAnActor
        )
        let typeReference: any ExprSyntaxProtocol = if
            let genericArgumentClause = overrideDeclarationType.genericArgumentClause
        {
            GenericSpecializationExprSyntax(
                expression: DeclReferenceExprSyntax(
                    baseName: overrideDeclarationType.name
                ),
                genericArgumentClause: genericArgumentClause
            )
        } else {
            DeclReferenceExprSyntax(
                baseName: overrideDeclarationType.name
            )
        }

        let initializer = InitializerClauseSyntax(
            value: FunctionCallExprSyntax(
                calledExpression: MemberAccessExprSyntax(
                    base: typeReference,
                    period: .periodToken(),
                    name: "makeSubscript"
                ),
                leftParen: .leftParenToken(),
                rightParen: .rightParenToken()
            ) {
                LabeledExprSyntax(
                    leadingTrivia: .newline,
                    label: "exposedSubscriptDescription",
                    colon: .colonToken(),
                    expression: FunctionCallExprSyntax(
                        calledExpression: DeclReferenceExprSyntax(
                            baseName: "MockImplementationDescription"
                        ),
                        leftParen: .leftParenToken(),
                        rightParen: .rightParenToken(),
                        argumentsBuilder: {
                            LabeledExprSyntax(
                                leadingTrivia: .newline,
                                label: "type",
                                colon: .colonToken(),
                                expression: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(
                                        baseName: .identifier(
                                            macroArguments.mockName
                                        )
                                    ),
                                    period: .periodToken(),
                                    name: .keyword(.self)
                                ),
                                trailingComma: .commaToken()
                            )
                            LabeledExprSyntax(
                                leadingTrivia: .newline,
                                label: "member",
                                colon: .colonToken(),
                                expression: StringLiteralExprSyntax(
                                    openingQuote: .stringQuoteToken(),
                                    content: "_\(name)",
                                    closingQuote: .stringQuoteToken()
                                ),
                                trailingTrivia: .newline
                            )
                        },
                        trailingTrivia: .newline
                    )
                )
            }
        )

        return VariableDeclSyntax(
            modifiers: modifiers,
            .let,
            name: PatternSyntax(
                IdentifierPatternSyntax(identifier: "__\(raw: name)")
            ),
            initializer: initializer
        )
    }

    /// Returns an exposed override declaration for the provided
    /// `subscriptDeclaration`.
    ///
    /// - Parameters:
    ///   - macroArguments: The arguments passed to the macro.
    ///   - subscriptDeclaration: The subscript declaration to which the macro
    ///     is attached.
    ///   - overrideDeclarationType: The type to apply to the exposed override
    ///     declaration.
    /// - Returns: An exposed override declaration.
    private static func exposedOverrideDeclaration(
        macroArguments: MacroArguments,
        subscriptDeclaration: SubscriptDeclSyntax,
        overrideDeclarationType: IdentifierTypeSyntax
    ) -> VariableDeclSyntax {
        let name = macroArguments.mockSubscriptName
        let modifiers = self.overrideDeclarationModifiers(
            from: subscriptDeclaration.modifiers,
            with: subscriptDeclaration.modifiers.accessLevel,
            isMockAnActor: macroArguments.isMockAnActor
        )
        let binding = PatternBindingSyntax(
            pattern: IdentifierPatternSyntax(identifier: "_\(raw: name)"),
            typeAnnotation: TypeAnnotationSyntax(type: overrideDeclarationType),
            accessorBlock: AccessorBlockSyntax(
                accessors: .getter(
                    CodeBlockItemListSyntax {
                        "self.__\(raw: name).`subscript`"
                    }
                )
            )
        )

        return VariableDeclSyntax(
            modifiers: modifiers,
            bindingSpecifier: .keyword(.var)
        ) {
            binding
        }
    }

    // MARK: Override Declaration Modifiers

    /// Returns modifiers to apply to an override declaration.
    ///
    /// - Parameters:
    ///   - modifiers: The modifiers taken from the subscript declaration.
    ///   - accessLevel: The access level to apply to the override declaration.
    ///   - isMockAnActor: A Boolean value indicating whether the encompassing
    ///     mock is an actor.
    /// - Returns: Modifiers to apply to an override declaration.
    private static func overrideDeclarationModifiers(
        from modifiers: DeclModifierListSyntax,
        with accessLevel: AccessLevelSyntax,
        isMockAnActor: Bool
    ) -> DeclModifierListSyntax {
        let shouldIncludeModifier: (DeclModifierSyntax) -> Bool = { modifier in
            let isModifierNonIsolated = modifier.name.tokenKind != .keyword(.nonisolated)

            return !modifier.isAccessLevel
                && (!isMockAnActor || !isModifierNonIsolated)
        }

        return DeclModifierListSyntax {
            if accessLevel != .internal {
                accessLevel.modifier
            }

            for modifier in modifiers where shouldIncludeModifier(modifier) {
                modifier.trimmed
            }

            if isMockAnActor {
                DeclModifierSyntax(name: .keyword(.nonisolated))
            }
        }
    }

    // MARK: Override Declaration Type

    /// Returns the type to apply to override declarations for the provided
    /// `subscriptDeclaration`.
    ///
    /// - Parameters:
    ///   - subscriptDeclaration: The subscript declaration for which to
    ///     determine the override declaration type.
    ///   - subscriptType: The type of subscript.
    /// - Returns: The type to apply to override declarations.
    private static func overrideDeclarationType(
        from subscriptDeclaration: SubscriptDeclSyntax,
        subscriptType: MockedSubscriptType
    ) -> IdentifierTypeSyntax {
        var typeName = "Mock"

        switch subscriptType {
        case let .readOnly(asyncSpecifier, throwsSpecifier):
            typeName += "ReadOnly"
            switch (asyncSpecifier, throwsSpecifier) {
            case (.async, .none):
                typeName += "Async"
            case (.async, .some):
                typeName += "AsyncThrowing"
            case (.none, .some):
                typeName += "Throwing"
            case (.none, .none):
                break
            }
        case .readWrite:
            typeName += "ReadWrite"
        }

        typeName += "Subscript"

        let parameters = subscriptDeclaration.parameterClause.parameters
        let keyType: TypeSyntax = if
            parameters.count == 1,
            let firstParameter = parameters.first
        {
            firstParameter.type.trimmed
        } else {
            TypeSyntax(
                TupleTypeSyntax(
                    elements: TupleTypeElementListSyntax(
                        parameters.enumerated().map { index, parameter in
                            let isLastParameter = index == parameters.count - 1

                            return TupleTypeElementSyntax(
                                type: parameter.type.trimmed,
                                trailingComma: isLastParameter ? nil : .commaToken()
                            )
                        }
                    )
                )
            )
        }

        let valueType = subscriptDeclaration.returnClause.type.trimmed

        let genericArgumentClause = GenericArgumentClauseSyntax {
            GenericArgumentSyntax(
                leadingTrivia: .newline.appending(.tab),
                argument: keyType,
                trailingComma: .commaToken()
            )
            GenericArgumentSyntax(
                leadingTrivia: .newline.appending(.tab),
                argument: valueType,
                trailingTrivia: .newline
            )
        }

        return IdentifierTypeSyntax(
            name: .identifier(typeName),
            genericArgumentClause: genericArgumentClause
        )
    }
}
