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

        let macroArguments = try MacroArguments(node: node)
        let methodName = macroArguments.mockMethodName
        let methodGenericParameterClause = methodDeclaration.genericParameterClause
        let methodGenericParameters = methodGenericParameterClause?.parameters
        let methodParameterClause = methodDeclaration.signature.parameterClause
        let methodParameters = methodParameterClause.parameters
        let methodReturnClause = methodDeclaration.signature.returnClause
        let methodGenericWhereClause = methodDeclaration.genericWhereClause

        let backingPropertyReference = "self.__\(methodName)"
        let invocationKeywordTokens = methodDeclaration.invocationKeywordTokens
        let joinedInvocationKeywordTokens = if invocationKeywordTokens.isEmpty {
            ""
        } else {
            invocationKeywordTokens
                .map(\.text)
                .joined(separator: " ")
                .appending(" ")
        }

        var body = joinedInvocationKeywordTokens + backingPropertyReference

        if methodParameters.isEmpty {
            body += ".invoke()"
        } else {
            body += ".recordInput((\n\t"

            var parameterNames: [String] = []
            var invokeArguments: [String] = []

            for parameter in methodParameters {
                let (_, didTypeEraseParameter) = self.type(
                    parameter.type,
                    typeErasedIfNecessaryUsing: methodGenericParameters,
                    typeConstrainedBy: methodGenericWhereClause
                )
                let parameterName = parameter.secondName ?? parameter.firstName
                let trimmedParameterName = parameterName.trimmed.text
                let invokeArgument: String

                if self.isInoutParameter(parameter), !didTypeEraseParameter {
                    invokeArgument = "&\(trimmedParameterName)"
                } else {
                    invokeArgument = trimmedParameterName
                }

                parameterNames.append(trimmedParameterName)
                invokeArguments.append(invokeArgument)

                if self.isConsumingParameter(parameter) {
                    body = "let \(parameterName) = \(parameterName)\n" + body
                }
            }

            body += parameterNames.joined(separator: ",\n\t") + "\n))"
            body += "\n\n"
            body += "let invoke = \(backingPropertyReference).closure()\n"

            if methodDeclaration.isThrowing {
                body += "\ndo {\n\t"
            }

            if methodReturnClause != nil {
                body += "let returnValue = "
            }

            body += """
            \(joinedInvocationKeywordTokens)\
            invoke\(methodReturnClause == nil ? "?" : "")(
                \(invokeArguments.joined(separator: ",\n\t"))
            )\n
            """

            if
                let returnType = methodReturnClause?.type.trimmed,
                self.type(
                    returnType,
                    typeErasedIfNecessaryUsing: methodGenericParameters,
                    typeConstrainedBy: methodGenericWhereClause
                ).didTypeErase
            {
                body += """
                guard
                    let returnValue = returnValue as? \(returnType)
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._\(methodName) \\
                        to expected return type \(returnType).
                        \"""
                    )
                }\n
                """
            }

            if methodReturnClause != nil {
                body += """
                \(backingPropertyReference).recordOutput(
                    \(
                        methodDeclaration.isThrowing
                            ? ".success(returnValue)"
                            : "returnValue"
                    )
                )
                return returnValue\(methodDeclaration.isThrowing ? "\n" : "")
                """
            }

            if methodDeclaration.isThrowing {
                body += """
                } catch {
                    \(backingPropertyReference).recordOutput(
                        \(methodReturnClause == nil ? "error" : ".failure(error)")
                    )
                    throw error
                }
                """
            }
        }

        return [
            "\(raw: body)"
        ]
    }

    // MARK: Attributed Parameters

    /// Returns a Boolean value indicating whether the provided `parameter` is
    /// an `inout` parameter.
    ///
    /// - Parameter parameter: A function parameter.
    /// - Returns: A Boolean value indicating whether the provided `parameter`
    ///   is an `inout` parameter.
    private static func isInoutParameter(
        _ parameter: FunctionParameterSyntax
    ) -> Bool {
        guard
            let attributedType = parameter.type.as(AttributedTypeSyntax.self)
        else {
            return false
        }

        return self.attributedType(attributedType, containsSpecifierKeyword: .inout)
    }

    /// Returns a Boolean value indicating whether the provided `parameter` is
    /// a `consuming` parameter.
    ///
    /// - Parameter parameter: A function parameter.
    /// - Returns: A Boolean value indicating whether the provided `parameter`
    ///   is a `consuming` parameter.
    private static func isConsumingParameter(
        _ parameter: FunctionParameterSyntax
    ) -> Bool {
        guard
            let attributedType = parameter.type.as(AttributedTypeSyntax.self)
        else {
            return false
        }

        return self.attributedType(attributedType, containsSpecifierKeyword: .consuming)
    }

    /// Returns a Boolean value indicating whether the provided `attributedType`
    /// contains a specifier with the provided `specifierKeyword`.
    ///
    /// - Parameters:
    ///   - attributedType: An attributed type.
    ///   - specifierKeyword: The keyword of the specifier to find in the
    ///     attributed type's specifiers.
    /// - Returns: A Boolean value indicating whether the provided
    ///   `attributedType` contains a specifier with the provided
    ///   `specifierKeyword`.
    private static func attributedType(
        _ attributedType: AttributedTypeSyntax,
        containsSpecifierKeyword specifierKeyword: Keyword
    ) -> Bool {
        attributedType.specifiers.contains { specifier in
            guard case let .simpleTypeSpecifier(specifier) = specifier else {
                return false
            }
            
            return specifier.specifier.tokenKind == .keyword(specifierKeyword)
        }
    }
}
