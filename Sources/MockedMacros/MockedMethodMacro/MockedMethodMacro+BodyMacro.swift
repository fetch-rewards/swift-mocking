//
//  MockedMethodMacro+BodyMacro.swift
//  MockedMacros
//
//  Created by Gray Campbell on 1/14/25.
//

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedMethodMacro: BodyMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
        in context: some MacroExpansionContext
    ) throws -> [CodeBlockItemSyntax] {
        guard let methodDeclaration = declaration.as(FunctionDeclSyntax.self) else {
            throw MacroError.canOnlyBeAppliedToMethodDeclarations
        }

        let methodName = methodDeclaration.name.trimmed
        let methodGenericParameterClause = methodDeclaration.genericParameterClause
        let methodGenericParameters = methodGenericParameterClause?.parameters
        let methodGenericWhereClause = methodDeclaration.genericWhereClause

        let invocationArguments = methodDeclaration.parameterVariableNames
        let invocationKeywordTokens = methodDeclaration.invocationKeywordTokens

        var backingImplementationInvocation = ""

        if !invocationKeywordTokens.isEmpty {
            let joinedInvocationKeywordTokens = invocationKeywordTokens
                .map(\.text)
                .joined(separator: " ")

            backingImplementationInvocation += "\(joinedInvocationKeywordTokens) "
        }

        backingImplementationInvocation += "self.__\(methodName).invoke"

        if invocationArguments.isEmpty {
            backingImplementationInvocation += "()"
        } else {
            let joinedInvocationArguments = invocationArguments
                .map(\.trimmed.text)
                .joined(separator: ", ")

            backingImplementationInvocation += "((\(joinedInvocationArguments)))"
        }

        guard
            let returnType = methodDeclaration.signature.returnClause?.type.trimmed,
            self.type(
                returnType,
                typeErasedIfNecessaryUsing: methodGenericParameters,
                typeConstrainedBy: methodGenericWhereClause
            ).didTypeErase
        else {
            return [
                "\(raw: backingImplementationInvocation)",
            ]
        }

        return [
            """
            guard 
                let value = \(raw: backingImplementationInvocation) as? \(returnType) 
            else {
                fatalError(
                    \"""
                    Unable to cast value returned by \\
                    self._\(methodName) \\
                    to expected return type \(returnType).
                    \"""
                )
            }
            """,
            "return value",
        ]
    }
}
