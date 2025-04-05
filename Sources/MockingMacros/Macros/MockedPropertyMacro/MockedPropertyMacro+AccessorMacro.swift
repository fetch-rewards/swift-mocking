//
//  MockedPropertyMacro+AccessorMacro.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedPropertyMacro: AccessorMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
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

        var accessors: [AccessorDeclSyntax] = [
            self.getAccessor(
                propertyType: macroArguments.propertyType,
                propertyBindingName: propertyBindingName
            )
        ]

        if let setAccessor = self.setAccessor(
            propertyType: macroArguments.propertyType,
            propertyBindingName: propertyBindingName
        ) {
            accessors.append(setAccessor)
        }

        return accessors
    }

    // MARK: Get Accessor

    /// Returns a `get` accessor for a property with the provided `propertyType`
    /// and `propertyBindingName`.
    ///
    /// - Parameters:
    ///   - propertyType: The type of property specified in the macro arguments.
    ///   - propertyBindingName: The name of the property binding.
    /// - Returns: A `get` accessor for a property with the provided
    ///   `propertyType` and `propertyBindingName`.
    private static func getAccessor(
        propertyType: MockedPropertyType,
        propertyBindingName: TokenSyntax
    ) -> AccessorDeclSyntax {
        var asyncSpecifier: TokenSyntax?
        var throwsClause: ThrowsClauseSyntax?
        var getterInvocationExpression: any ExprSyntaxProtocol

        getterInvocationExpression = FunctionCallExprSyntax(
            calledExpression: MemberAccessExprSyntax(
                base: MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                    period: .periodToken(),
                    name: "__\(propertyBindingName)"
                ),
                period: .periodToken(),
                name: "get"
            ),
            leftParen: .leftParenToken(),
            rightParen: .rightParenToken()
        ) {}

        if case .async = propertyType.getterAsyncSpecifier {
            asyncSpecifier = .keyword(.async)
            getterInvocationExpression = AwaitExprSyntax(
                awaitKeyword: .keyword(.await),
                expression: getterInvocationExpression
            )
        }

        if case .throws = propertyType.getterThrowsSpecifier {
            throwsClause = ThrowsClauseSyntax(
                throwsSpecifier: .keyword(.throws)
            )
            getterInvocationExpression = TryExprSyntax(
                tryKeyword: .keyword(.try),
                expression: getterInvocationExpression
            )
        }

        let effectSpecifiers: AccessorEffectSpecifiersSyntax? = switch (
            asyncSpecifier,
            throwsClause
        ) {
        case (.some, _), (_, .some):
            AccessorEffectSpecifiersSyntax(
                asyncSpecifier: asyncSpecifier,
                throwsClause: throwsClause
            )
        case (.none, .none):
            nil
        }

        return AccessorDeclSyntax(
            accessorSpecifier: .keyword(.get),
            effectSpecifiers: effectSpecifiers
        ) {
            getterInvocationExpression
        }
    }

    // MARK: Set Accessor

    /// Returns a `set` accessor for a property with the provided `propertyType`
    /// and `propertyBindingName`, if applicable.
    ///
    /// - Parameters:
    ///   - propertyType: The type of property specified in the macro arguments.
    ///   - propertyBindingName: The name of the property binding.
    /// - Returns: A `set` accessor for a property with the provided
    ///   `propertyType` and `propertyBindingName`, if applicable.
    private static func setAccessor(
        propertyType: MockedPropertyType,
        propertyBindingName: TokenSyntax
    ) -> AccessorDeclSyntax? {
        guard case .readWrite = propertyType else {
            return nil
        }

        return AccessorDeclSyntax(
            accessorSpecifier: .keyword(.set)
        ) {
            FunctionCallExprSyntax(
                calledExpression: MemberAccessExprSyntax(
                    base: MemberAccessExprSyntax(
                        base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                        period: .periodToken(),
                        name: "__\(propertyBindingName)"
                    ),
                    period: .periodToken(),
                    name: "set"
                ),
                leftParen: .leftParenToken(),
                rightParen: .rightParenToken()
            ) {
                LabeledExprSyntax(
                    expression: DeclReferenceExprSyntax(baseName: "newValue")
                )
            }
        }
    }
}
