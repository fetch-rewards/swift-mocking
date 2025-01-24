//
//  MockedMethodMacro+PeerMacro.swift
//  MockedMacros
//
//  Created by Gray Campbell on 1/14/25.
//

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedMethodMacro: PeerMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let methodDeclaration = declaration.as(FunctionDeclSyntax.self) else {
            throw MacroError.canOnlyBeAppliedToMethodDeclarations
        }

        let macroArguments = try MacroArguments(node: node)
        let overrideDeclarationType = self.overrideDeclarationType(
            from: methodDeclaration
        )
        let backingOverrideDeclaration = self.backingOverrideDeclaration(
            macroArguments: macroArguments,
            methodDeclaration: methodDeclaration,
            overrideDeclarationType: overrideDeclarationType
        )
        let exposedOverrideDeclaration = self.exposedOverrideDeclaration(
            macroArguments: macroArguments,
            methodDeclaration: methodDeclaration,
            overrideDeclarationType: overrideDeclarationType
        )

        return [
            DeclSyntax(backingOverrideDeclaration),
            DeclSyntax(exposedOverrideDeclaration),
        ]
    }

    // MARK: Override Declarations

    /// Returns a backing override declaration for the provided
    /// `methodDeclaration`.
    ///
    /// - Parameters:
    ///   - macroArguments: The arguments passed to the macro.
    ///   - methodDeclaration: The method declaration to which the macro is
    ///     attached.
    ///   - overrideDeclarationType: The type to apply to the backing override
    ///     declaration.
    /// - Returns: A backing override declaration for the provided
    ///   `methodDeclaration`.
    private static func backingOverrideDeclaration(
        macroArguments: MacroArguments,
        methodDeclaration: FunctionDeclSyntax,
        overrideDeclarationType: IdentifierTypeSyntax
    ) -> VariableDeclSyntax {
        let methodName = methodDeclaration.name.trimmed
        let modifiers = self.overrideDeclarationModifiers(
            from: methodDeclaration.modifiers,
            with: AccessLevelSyntax.private,
            isMockAnActor: macroArguments.isMockAnActor
        )
        let name = IdentifierPatternSyntax(identifier: "__\(methodName)")
        let typeReference: any ExprSyntaxProtocol

        if let genericArgumentClause = overrideDeclarationType.genericArgumentClause {
            typeReference = GenericSpecializationExprSyntax(
                expression: DeclReferenceExprSyntax(
                    baseName: overrideDeclarationType.name
                ),
                genericArgumentClause: genericArgumentClause
            )
        } else {
            typeReference = DeclReferenceExprSyntax(
                baseName: overrideDeclarationType.name
            )
        }

        let initializer = InitializerClauseSyntax(
            value: FunctionCallExprSyntax(
                calledExpression: MemberAccessExprSyntax(
                    base: typeReference,
                    period: .periodToken(),
                    name: "makeMethod"
                ),
                leftParen: .leftParenToken(),
                rightParen: .rightParenToken()
            ) {
                if methodDeclaration.signature.returnClause != nil {
                    LabeledExprSyntax(
                        leadingTrivia: .newline,
                        label: "exposedMethodDescription",
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
                                            baseName: macroArguments.mockName
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
                                        content: "_\(methodName)",
                                        closingQuote: .stringQuoteToken()
                                    ),
                                    trailingTrivia: .newline
                                )
                            },
                            trailingTrivia: .newline
                        )
                    )
                }
            }
        )

        return VariableDeclSyntax(
            modifiers: modifiers,
            .let,
            name: PatternSyntax(name),
            initializer: initializer
        )
    }

    /// Returns an exposed override declaration for the provided
    /// `methodDeclaration`.
    ///
    /// - Parameters:
    ///   - macroArguments: The arguments passed to the macro.
    ///   - methodDeclaration: The method declaration to which the macro is
    ///     attached.
    ///   - overrideDeclarationType: The type to apply to the exposed override
    ///     declaration.
    /// - Returns: An exposed override declaration for the provided
    ///   `methodDeclaration`.
    private static func exposedOverrideDeclaration(
        macroArguments: MacroArguments,
        methodDeclaration: FunctionDeclSyntax,
        overrideDeclarationType: IdentifierTypeSyntax
    ) -> VariableDeclSyntax {
        let methodName = methodDeclaration.name.trimmed
        let modifiers = self.overrideDeclarationModifiers(
            from: methodDeclaration.modifiers,
            with: methodDeclaration.accessLevel,
            isMockAnActor: macroArguments.isMockAnActor
        )
        let binding = PatternBindingSyntax(
            pattern: IdentifierPatternSyntax(identifier: "_\(methodName)"),
            typeAnnotation: TypeAnnotationSyntax(type: overrideDeclarationType),
            accessorBlock: AccessorBlockSyntax(
                accessors: .getter(
                    CodeBlockItemListSyntax {
                        "self.__\(methodName).method"
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

    /// Returns modifiers to apply to an override declaration, generated using
    /// the provided `modifiers` from the method being backed by the override
    /// declaration and the provided `accessLevel`.
    ///
    /// - Parameters:
    ///   - modifiers: The modifiers taken from the method declaration being
    ///     backed by the override declaration.
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
    /// `methodDeclaration`.
    ///
    /// - Parameter methodDeclaration: The method declaration for which to
    ///   determine the override declaration type.
    /// - Returns: The type to apply to override declarations for the provided
    ///   `methodDeclaration`.
    private static func overrideDeclarationType(
        from methodDeclaration: FunctionDeclSyntax
    ) -> IdentifierTypeSyntax {
        var name = "Mock"
        var genericArguments: [GenericArgumentSyntax] = []

        self.parseReturnClause(
            from: methodDeclaration,
            overrideDeclarationTypeName: &name,
            overrideDeclarationTypeGenericArguments: &genericArguments
        )
        self.parseEffectSpecifiers(
            from: methodDeclaration,
            overrideDeclarationTypeName: &name
        )
        name += "Method"
        self.parseParameters(
            from: methodDeclaration,
            overrideDeclarationTypeName: &name,
            overrideDeclarationTypeGenericArguments: &genericArguments
        )

        var genericArgumentClause: GenericArgumentClauseSyntax?

        if !genericArguments.isEmpty {
            genericArgumentClause = GenericArgumentClauseSyntax(
                arguments: GenericArgumentListSyntax(genericArguments)
            )
        }

        return IdentifierTypeSyntax(
            name: .identifier(name),
            genericArgumentClause: genericArgumentClause
        )
    }

    /// Updates the provided `overrideDeclarationTypeName` and
    /// `overrideDeclarationTypeGenericArguments` with information parsed from
    /// the return clause of the provided `methodDeclaration`.
    ///
    /// - Parameters:
    ///   - methodDeclaration: The method declaration to parse.
    ///   - overrideDeclarationTypeName: The override declaration type name to
    ///     update with the information parsed from the return clause of the
    ///     provided `methodDeclaration`.
    ///   - overrideDeclarationTypeGenericArguments: The override declaration
    ///     type's generic arguments to update with the information parsed from
    ///     the return clause of the provided `methodDeclaration`.
    private static func parseReturnClause(
        from methodDeclaration: FunctionDeclSyntax,
        overrideDeclarationTypeName: inout String,
        overrideDeclarationTypeGenericArguments: inout [GenericArgumentSyntax]
    ) {
        guard let returnClause = methodDeclaration.signature.returnClause else {
            overrideDeclarationTypeName += "Void"
            return
        }

        let methodGenericParameterClause = methodDeclaration.genericParameterClause
        let (returnType, _) = self.type(
            returnClause.type.trimmed,
            typeErasedIfNecessaryUsing: methodGenericParameterClause?.parameters,
            typeConstrainedBy: methodDeclaration.genericWhereClause
        )
        let returnTypeGenericArgument = GenericArgumentSyntax(
            leadingTrivia: .newline.appending(.tab),
            argument: returnType.trimmed,
            trailingTrivia: .newline
        )

        overrideDeclarationTypeName += "Returning"
        overrideDeclarationTypeGenericArguments.append(returnTypeGenericArgument)
    }

    /// Updates the provided `overrideDeclarationTypeName` with information
    /// parsed from the effect specifiers of the provided `methodDeclaration`.
    ///
    /// - Parameters:
    ///   - methodDeclaration: The method declaration to parse.
    ///   - overrideDeclarationTypeName: The override declaration type name to
    ///     update with the information parsed from the effect specifiers of the
    ///     provided `methodDeclaration`.
    private static func parseEffectSpecifiers(
        from methodDeclaration: FunctionDeclSyntax,
        overrideDeclarationTypeName: inout String
    ) {
        if methodDeclaration.isAsync {
            overrideDeclarationTypeName += "Async"
        }

        if methodDeclaration.isThrowing {
            overrideDeclarationTypeName += "Throwing"
        }
    }

    /// Updates the provided `overrideDeclarationTypeName` and
    /// `overrideDeclarationTypeGenericArguments` with information parsed from
    /// the parameters of the provided `methodDeclaration`.
    ///
    /// - Parameters:
    ///   - methodDeclaration: The method declaration to parse.
    ///   - overrideDeclarationTypeName: The override declaration type name to
    ///     update with the information parsed from the parameters of the
    ///     provided `methodDeclaration`.
    ///   - overrideDeclarationTypeGenericArguments: The override declaration
    ///     type's generic arguments to update with the information parsed from
    ///     the parameters of the provided `methodDeclaration`.
    private static func parseParameters(
        from methodDeclaration: FunctionDeclSyntax,
        overrideDeclarationTypeName: inout String,
        overrideDeclarationTypeGenericArguments: inout [GenericArgumentSyntax]
    ) {
        let methodParameters = methodDeclaration.signature.parameterClause.parameters

        guard let arguments = methodParameters.toTupleTypeSyntax() else {
            overrideDeclarationTypeName += "WithoutParameters"
            return
        }

        let methodGenericParameterClause = methodDeclaration.genericParameterClause
        let elements = arguments.elements.map { element in
            let (elementType, _) = self.type(
                element.type,
                typeErasedIfNecessaryUsing: methodGenericParameterClause?.parameters,
                typeConstrainedBy: methodDeclaration.genericWhereClause
            )

            return element.with(\.type, elementType.trimmed)
        }
        let argumentsGenericArgument = GenericArgumentSyntax(
            leadingTrivia: .newline.appending(.tab),
            argument: arguments.with(
                \.elements,
                 TupleTypeElementListSyntax(elements)
            ),
            trailingComma: overrideDeclarationTypeGenericArguments.isEmpty
                ? nil
                : .commaToken(),
            trailingTrivia: overrideDeclarationTypeGenericArguments.isEmpty
                ? .newline
                : nil
        )

        overrideDeclarationTypeName += "WithParameters"
        overrideDeclarationTypeGenericArguments.insert(
            argumentsGenericArgument,
            at: .zero
        )
    }
}
