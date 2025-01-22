//
//  MockedPropertyMacro+PeerMacro.swift
//  MockedMacros
//
//  Created by Gray Campbell on 1/17/25.
//

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedPropertyMacro: PeerMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let propertyDeclaration = declaration.as(VariableDeclSyntax.self) else {
            throw MacroError.canOnlyBeAppliedToPropertyDeclarations
        }

        guard
            propertyDeclaration.bindings.count == 1,
            let propertyBinding = propertyDeclaration.bindings.first
        else {
            throw MacroError.canOnlyBeAppliedToSingleBindingPropertyDeclarations
        }

        guard
            let propertyBindingPattern = propertyBinding.pattern.as(
                IdentifierPatternSyntax.self
            )
        else {
            throw MacroError.unableToParsePropertyBindingName
        }

        let propertyBindingName = propertyBindingPattern.identifier
        let macroArguments = try MacroArguments(node: node)
        let overrideDeclarationType = self.overrideDeclarationType(
            from: propertyBinding,
            propertyType: macroArguments.propertyType
        )
        let backingOverrideDeclaration = self.backingOverrideDeclaration(
            macroArguments: macroArguments,
            propertyBinding: propertyBinding,
            propertyBindingName: propertyBindingName,
            propertyDeclaration: propertyDeclaration,
            overrideDeclarationType: overrideDeclarationType
        )
        let exposedOverrideDeclaration = self.exposedOverrideDeclaration(
            macroArguments: macroArguments,
            propertyBinding: propertyBinding,
            propertyBindingName: propertyBindingName,
            propertyDeclaration: propertyDeclaration,
            overrideDeclarationType: overrideDeclarationType
        )

        return [
            DeclSyntax(backingOverrideDeclaration),
            DeclSyntax(exposedOverrideDeclaration),
        ]
    }

    // MARK: Override Declarations

    /// Returns a backing override declaration for the provided
    /// `propertyBinding` with the provided `propertyBindingName` from the
    /// provided `propertyDeclaration`.
    ///
    /// - Parameters:
    ///   - macroArguments: The arguments passed to the macro.
    ///   - propertyBinding: The property binding for which to create a backing
    ///     override declaration.
    ///   - propertyBindingName: The name of the provided `propertyBinding`.
    ///   - propertyDeclaration: The property declaration that contains the
    ///     `propertyBinding` and to which the macro is attached.
    ///   - overrideDeclarationType: The type to apply to the backing override
    ///     declaration.
    /// - Returns: A backing override declaration for the provided
    ///   `propertyBinding` with the provided `propertyBindingName` from the
    ///   provided `propertyDeclaration`.
    private static func backingOverrideDeclaration(
        macroArguments: MacroArguments,
        propertyBinding: PatternBindingSyntax,
        propertyBindingName: TokenSyntax,
        propertyDeclaration: VariableDeclSyntax,
        overrideDeclarationType: IdentifierTypeSyntax
    ) -> VariableDeclSyntax {
        let modifiers = self.overrideDeclarationModifiers(
            from: propertyDeclaration.modifiers,
            with: AccessLevelSyntax.private,
            isMockAnActor: macroArguments.isMockAnActor
        )
        let name = IdentifierPatternSyntax(identifier: "__\(propertyBindingName)")
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
                    name: "makeProperty"
                ),
                leftParen: .leftParenToken(),
                rightParen: .rightParenToken()
            ) {
                LabeledExprSyntax(
                    leadingTrivia: .newline,
                    label: "exposedPropertyDescription",
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
                                    content: "_\(propertyBindingName)",
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
            name: PatternSyntax(name),
            initializer: initializer
        )
    }

    /// Returns an exposed override declaration for the provided
    /// `propertyBinding` with the provided `propertyBindingName` from the
    /// provided `propertyDeclaration`.
    ///
    /// - Parameters:
    ///   - macroArguments: The arguments passed to the macro.
    ///   - propertyBinding: The property binding for which to create an exposed
    ///     override declaration.
    ///   - propertyBindingName: The name of the provided `propertyBinding`.
    ///   - propertyDeclaration: The property declaration that contains the
    ///     `propertyBinding` and to which the macro is attached.
    ///   - overrideDeclarationType: The type to apply to the exposed override
    ///     declaration.
    /// - Returns: An exposed override declaration for the provided
    ///   `propertyBinding` with the provided `propertyBindingName` from the
    ///   provided `propertyDeclaration`.
    private static func exposedOverrideDeclaration(
        macroArguments: MacroArguments,
        propertyBinding: PatternBindingSyntax,
        propertyBindingName: TokenSyntax,
        propertyDeclaration: VariableDeclSyntax,
        overrideDeclarationType: IdentifierTypeSyntax
    ) -> VariableDeclSyntax {
        let modifiers = self.overrideDeclarationModifiers(
            from: propertyDeclaration.modifiers,
            with: propertyDeclaration.accessLevel,
            isMockAnActor: macroArguments.isMockAnActor
        )
        let binding = PatternBindingSyntax(
            pattern: IdentifierPatternSyntax(identifier: "_\(propertyBindingName)"),
            typeAnnotation: TypeAnnotationSyntax(type: overrideDeclarationType),
            accessorBlock: AccessorBlockSyntax(
                accessors: .getter(
                    CodeBlockItemListSyntax {
                        "self.__\(propertyBindingName).property"
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
    /// `propertyBinding`.
    ///
    /// - Parameters:
    ///   - propertyBinding: The property binding for which to determine the
    ///     override declaration type.
    ///   - propertyType: The type of property to which the property binding
    ///     belongs.
    /// - Returns: The type to apply to override declarations for the provided
    ///   `propertyBinding`.
    private static func overrideDeclarationType(
        from propertyBinding: PatternBindingSyntax,
        propertyType: MockedPropertyType
    ) -> IdentifierTypeSyntax {
        var name = "Mock"

        switch propertyType {
        case let .readOnly(asyncSpecifier, throwsSpecifier):
            name += "ReadOnly"

            switch (asyncSpecifier, throwsSpecifier) {
            case (.async, .none):
                name += "Async"
            case (.async, .some):
                name += "AsyncThrowing"
            case (.none, .some):
                name += "Throwing"
            case (.none, .none):
                break
            }
        case .readWrite:
            name += "ReadWrite"
        }

        name += "Property"

        let genericArgumentClause = propertyBinding.typeAnnotation.map { typeAnnotation in
            GenericArgumentClauseSyntax {
                GenericArgumentSyntax(
                    leadingTrivia: .newline.appending(.tab),
                    argument: typeAnnotation.type.trimmed,
                    trailingTrivia: .newline
                )
            }
        }

        return IdentifierTypeSyntax(
            name: .identifier(name),
            genericArgumentClause: genericArgumentClause
        )
    }
}
