//
//  MockedSubscriptMacro+AccessorMacro.swift
//
//  Copyright © 2026 Fetch.
//

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedSubscriptMacro: AccessorMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard let subscriptDeclaration = declaration.as(SubscriptDeclSyntax.self) else {
            throw MacroError.canOnlyBeAppliedToSubscriptDeclarations
        }

        let macroArguments = try MacroArguments(node: node)
        let subscriptName = macroArguments.mockSubscriptName
        let keyArgument = self.keyArgumentExpression(from: subscriptDeclaration)

        var accessors: [AccessorDeclSyntax] = [
            self.getAccessor(
                subscriptName: subscriptName,
                keyArgument: keyArgument
            ),
        ]

        if case .readWrite = macroArguments.subscriptType {
            accessors.append(
                self.setAccessor(
                    subscriptName: subscriptName,
                    keyArgument: keyArgument
                )
            )
        }

        return accessors
    }

    // MARK: Get Accessor

    /// Returns a `get` accessor for a subscript with the provided
    /// `subscriptName` and `keyArgument`.
    ///
    /// - Parameters:
    ///   - subscriptName: The disambiguated name of the mock subscript backing.
    ///   - keyArgument: The key argument expression to pass to `get(_:)`.
    /// - Returns: A `get` accessor.
    private static func getAccessor(
        subscriptName: String,
        keyArgument: ExprSyntax
    ) -> AccessorDeclSyntax {
        AccessorDeclSyntax(accessorSpecifier: .keyword(.get)) {
            FunctionCallExprSyntax(
                calledExpression: MemberAccessExprSyntax(
                    base: MemberAccessExprSyntax(
                        base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                        period: .periodToken(),
                        name: "__\(raw: subscriptName)"
                    ),
                    period: .periodToken(),
                    name: "get"
                ),
                leftParen: .leftParenToken(),
                rightParen: .rightParenToken()
            ) {
                LabeledExprSyntax(expression: keyArgument)
            }
        }
    }

    // MARK: Set Accessor

    /// Returns a `set` accessor for a subscript with the provided
    /// `subscriptName` and `keyArgument`.
    ///
    /// - Parameters:
    ///   - subscriptName: The disambiguated name of the mock subscript backing.
    ///   - keyArgument: The key argument expression to pass to `set(_:_:)`.
    /// - Returns: A `set` accessor.
    private static func setAccessor(
        subscriptName: String,
        keyArgument: ExprSyntax
    ) -> AccessorDeclSyntax {
        AccessorDeclSyntax(accessorSpecifier: .keyword(.set)) {
            FunctionCallExprSyntax(
                calledExpression: MemberAccessExprSyntax(
                    base: MemberAccessExprSyntax(
                        base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                        period: .periodToken(),
                        name: "__\(raw: subscriptName)"
                    ),
                    period: .periodToken(),
                    name: "set"
                ),
                leftParen: .leftParenToken(),
                rightParen: .rightParenToken()
            ) {
                LabeledExprSyntax(
                    expression: keyArgument,
                    trailingComma: .commaToken()
                )
                LabeledExprSyntax(
                    expression: DeclReferenceExprSyntax(baseName: "newValue")
                )
            }
        }
    }

    // MARK: Key Argument

    /// Returns the key argument expression to pass to the getter or setter.
    ///
    /// For a single-parameter subscript, this is just the parameter name. For
    /// a multi-parameter subscript, this is a tuple expression packing all
    /// parameter names.
    ///
    /// - Parameter subscriptDeclaration: The subscript declaration from which
    ///   to build the key argument expression.
    /// - Returns: A key argument expression.
    private static func keyArgumentExpression(
        from subscriptDeclaration: SubscriptDeclSyntax
    ) -> ExprSyntax {
        let parameters = subscriptDeclaration.parameterClause.parameters

        if parameters.count == 1, let firstParameter = parameters.first {
            let name = firstParameter.secondName ?? firstParameter.firstName

            return ExprSyntax(
                DeclReferenceExprSyntax(baseName: name.trimmed)
            )
        }

        let tupleElements = LabeledExprListSyntax(
            parameters.enumerated().map { index, parameter in
                let name = parameter.secondName ?? parameter.firstName
                let isLastParameter = index == parameters.count - 1

                return LabeledExprSyntax(
                    expression: DeclReferenceExprSyntax(baseName: name.trimmed),
                    trailingComma: isLastParameter ? nil : .commaToken()
                )
            }
        )

        return ExprSyntax(TupleExprSyntax(elements: tupleElements))
    }
}
