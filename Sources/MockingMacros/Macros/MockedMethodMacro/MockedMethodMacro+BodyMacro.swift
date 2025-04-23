//
//  MockedMethodMacro+BodyMacro.swift
//  MockingMacros
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
        let methodReturnType = methodReturnClause?.type.trimmed
        let methodGenericWhereClause = methodDeclaration.genericWhereClause
        let methodHasReturnType = methodReturnType != nil
        let methodHasGenericReturnType: Bool = if let methodReturnType {
            self.type(
                methodReturnType,
                typeErasedIfNecessaryUsing: methodGenericParameters,
                typeConstrainedBy: methodGenericWhereClause
            )
            .didTypeErase
        } else {
            false
        }

        let isMethodThrowingAndReturning = methodDeclaration.isThrowing && methodHasReturnType
        let backingPropertyAccessExpression = self.backingPropertyAccessExpression(
            methodName: methodName
        )

        var body: [CodeBlockItemSyntax] = []

        let invokeClosureCallExpression: any ExprSyntaxProtocol

        if methodParameters.isEmpty {
            invokeClosureCallExpression = self.invokeClosureCallExpression(
                isAsync: methodDeclaration.isAsync,
                isThrowing: methodDeclaration.isThrowing,
                isOptional: false,
                backingPropertyAccessExpression: backingPropertyAccessExpression
            )
        } else {
            var recordInputClosureCallArguments: [LabeledExprSyntax] = []
            var invokeClosureCallArguments: [LabeledExprSyntax] = []

            for parameter in methodParameters {
                let (_, didTypeEraseParameter) = self.type(
                    parameter.type,
                    typeErasedIfNecessaryUsing: methodGenericParameters,
                    typeConstrainedBy: methodGenericWhereClause
                )
                let parameterName = (parameter.secondName ?? parameter.firstName).trimmed
                let parameterReferenceExpression = DeclReferenceExprSyntax(
                    baseName: parameterName
                )

                let recordInputClosureCallArgument = LabeledExprSyntax(
                    expression: parameterReferenceExpression
                )
                let invokeClosureCallArgument: LabeledExprSyntax

                if self.isInoutParameter(parameter), !didTypeEraseParameter {
                    invokeClosureCallArgument = LabeledExprSyntax(
                        expression: InOutExprSyntax(
                            expression: parameterReferenceExpression
                        )
                    )
                } else {
                    invokeClosureCallArgument = recordInputClosureCallArgument
                }

                recordInputClosureCallArguments.append(recordInputClosureCallArgument)
                invokeClosureCallArguments.append(invokeClosureCallArgument)

                if self.isConsumingParameter(parameter) {
                    let parameterVariableDeclaration = self.parameterVariableDeclaration(
                        parameterName: parameterName
                    )

                    body.append(self.codeBlockItem(parameterVariableDeclaration))
                }
            }

            let recordInputClosureCallExpression = self.recordInputClosureCallExpression(
                backingPropertyAccessExpression: backingPropertyAccessExpression,
                arguments: recordInputClosureCallArguments
            )
            let invokeVariableDeclaration = self.invokeVariableDeclaration(
                backingPropertyAccessExpression: backingPropertyAccessExpression
            )
            invokeClosureCallExpression = self.invokeClosureCallExpression(
                isAsync: methodDeclaration.isAsync,
                isThrowing: methodDeclaration.isThrowing,
                isOptional: methodReturnType == nil,
                arguments: invokeClosureCallArguments
            )

            body.append(self.codeBlockItem(recordInputClosureCallExpression))
            body.append(self.codeBlockItem(invokeVariableDeclaration))
        }

        if let methodReturnType {
            let returnValueVariableDeclaration = self.returnValueVariableDeclaration(
                initializerValue: invokeClosureCallExpression
            )

            body.append(self.codeBlockItem(returnValueVariableDeclaration))

            if methodHasGenericReturnType {
                let genericReturnValueGuardStatement = self.genericReturnValueGuardStatement(
                    methodName: methodName,
                    methodReturnType: methodReturnType
                )

                body.append(self.codeBlockItem(genericReturnValueGuardStatement))
            }

            if !methodParameters.isEmpty {
                let recordOutputClosureCallArgument = self.recordOutputClosureCallArgument(
                    value: "returnValue",
                    resultTypeCaseName: "success",
                    isMethodThrowingAndReturning: isMethodThrowingAndReturning
                )
                let recordOutputClosureCallExpression = self.recordOutputClosureCallExpression(
                    backingPropertyAccessExpression: backingPropertyAccessExpression,
                    argument: recordOutputClosureCallArgument
                )

                body.append(self.codeBlockItem(recordOutputClosureCallExpression))
            }

            body.append(self.codeBlockItem(self.returnValueReturnStatement()))
        } else {
            body.append(self.codeBlockItem(invokeClosureCallExpression))
        }

        if methodDeclaration.isThrowing, !methodParameters.isEmpty {
            let doCatchStatement = DoStmtSyntax(
                body: CodeBlockSyntax(
                    statements: CodeBlockItemListSyntax(body)
                ),
                catchClauses: CatchClauseListSyntax {
                    CatchClauseSyntax {
                        self.codeBlockItem(
                            self.recordOutputClosureCallExpression(
                                backingPropertyAccessExpression: backingPropertyAccessExpression,
                                argument: self.recordOutputClosureCallArgument(
                                    value: "error",
                                    resultTypeCaseName: "failure",
                                    isMethodThrowingAndReturning: isMethodThrowingAndReturning
                                )
                            )
                        )

                        self.codeBlockItem(self.thrownErrorThrowStatement())
                    }
                }
            )

            body = [self.codeBlockItem(doCatchStatement)]
        }

        return body
    }

    // MARK: Body

    /// Returns a code block item for the provided `declaration`.
    ///
    /// - Parameter declaration: The declaration with which to create the code
    ///   block item.
    /// - Returns: A code block item for the provided `declaration`.
    private static func codeBlockItem(
        _ declaration: any DeclSyntaxProtocol
    ) -> CodeBlockItemSyntax {
        CodeBlockItemSyntax(item: .decl(DeclSyntax(declaration)))
    }

    /// Returns a code block item for the provided `expression`.
    ///
    /// - Parameter expression: The expression with which to create the code
    ///   block item.
    /// - Returns: A code block item for the provided `expression`.
    private static func codeBlockItem(
        _ expression: any ExprSyntaxProtocol
    ) -> CodeBlockItemSyntax {
        CodeBlockItemSyntax(item: .expr(ExprSyntax(expression)))
    }

    /// Returns a code block item for the provided `statement`.
    ///
    /// - Parameter statement: The statement with which to create the code
    ///   block item.
    /// - Returns: A code block item for the provided `statement`.
    private static func codeBlockItem(
        _ statement: any StmtSyntaxProtocol
    ) -> CodeBlockItemSyntax {
        CodeBlockItemSyntax(item: .stmt(StmtSyntax(statement)))
    }

    /// Returns a variable declaration for the parameter with the provided
    /// `parameterName`.
    ///
    /// Variable declarations are created for `consuming` parameters so that the
    /// parameter is only consumed once.
    ///
    /// - Parameter parameterName: The name of the parameter for which to create
    ///   a variable declaration.
    /// - Returns: A variable declaration for the parameter with the provided
    ///   `parameterName`.
    private static func parameterVariableDeclaration(
        parameterName: TokenSyntax
    ) -> VariableDeclSyntax {
        VariableDeclSyntax(
            .let,
            name: PatternSyntax(
                IdentifierPatternSyntax(identifier: parameterName)
            ),
            initializer: InitializerClauseSyntax(
                value: DeclReferenceExprSyntax(baseName: parameterName)
            )
        )
    }

    /// Returns a backing property access expression for the method with the
    /// provided `methodName`.
    ///
    /// - Parameter methodName: The name of the method for which to create the
    ///   backing property access expression.
    /// - Returns: A backing property access expression for the method with the
    ///   provided `methodName`.
    private static func backingPropertyAccessExpression(
        methodName: String
    ) -> MemberAccessExprSyntax {
        MemberAccessExprSyntax(
            base: DeclReferenceExprSyntax(baseName: "self"),
            name: .identifier("__\(methodName)")
        )
    }

    /// Returns a `recordInput` closure call expression.
    ///
    /// - Parameters:
    ///   - backingPropertyAccessExpression: The backing property access
    ///     expression on which to call `recordInput`.
    ///   - arguments: The arguments with which to invoke the `recordInput`
    ///     closure.
    /// - Returns: A `recordInput` closure call expression.
    private static func recordInputClosureCallExpression(
        backingPropertyAccessExpression: MemberAccessExprSyntax,
        arguments: [LabeledExprSyntax]
    ) -> FunctionCallExprSyntax {
        FunctionCallExprSyntax(
            calledExpression: MemberAccessExprSyntax(
                base: backingPropertyAccessExpression,
                name: "recordInput"
            ),
            leftParen: .leftParenToken(),
            rightParen: .rightParenToken(leadingTrivia: .newline)
        ) {
            LabeledExprSyntax(
                expression: TupleExprSyntax(
                    leftParen: .leftParenToken(leadingTrivia: .newline),
                    rightParen: .rightParenToken(leadingTrivia: .newline)
                ) {
                    for argument in arguments {
                        argument.with(\.leadingTrivia, .newline)
                    }
                }
            )
        }
    }

    /// Returns an `_invoke` variable declaration.
    ///
    /// - Parameter backingPropertyAccessExpression: The backing property access
    ///   expression on which to call `closure`
    /// - Returns: An `_invoke` variable declaration.
    private static func invokeVariableDeclaration(
        backingPropertyAccessExpression: MemberAccessExprSyntax
    ) -> VariableDeclSyntax {
        VariableDeclSyntax(
            .let,
            name: PatternSyntax(
                IdentifierPatternSyntax(identifier: "_invoke")
            ),
            initializer: InitializerClauseSyntax(
                value: FunctionCallExprSyntax(
                    callee: MemberAccessExprSyntax(
                        base: backingPropertyAccessExpression,
                        name: "closure"
                    )
                )
            )
        )
    }

    /// Returns an `invoke` closure call expression.
    ///
    /// - Parameters:
    ///   - isAsync: A Boolean value indicating whether the `invoke` closure is
    ///     async.
    ///   - isThrowing: A Boolean value indicating whether the `invoke` closure
    ///     is throwing.
    ///   - isOptional: A Boolean value indicating whether the `invoke` closure
    ///     is optional.
    ///   - backingPropertyAccessExpression: The backing property access
    ///     expression on which to call `invoke`.
    ///   - arguments: The arguments with which to invoke the `invoke` closure.
    /// - Returns: A `invoke` closure call expression.
    private static func invokeClosureCallExpression(
        isAsync: Bool,
        isThrowing: Bool,
        isOptional: Bool,
        backingPropertyAccessExpression: MemberAccessExprSyntax? = nil,
        arguments: [LabeledExprSyntax] = []
    ) -> any ExprSyntaxProtocol {
        var expression: any ExprSyntaxProtocol = if let backingPropertyAccessExpression {
            MemberAccessExprSyntax(
                base: backingPropertyAccessExpression,
                name: "invoke"
            )
        } else {
            DeclReferenceExprSyntax(baseName: "_invoke")
        }

        if isOptional {
            expression = OptionalChainingExprSyntax(expression: expression)
        }

        expression = FunctionCallExprSyntax(
            calledExpression: expression,
            leftParen: .leftParenToken(),
            rightParen: .rightParenToken(leadingTrivia: .newline)
        ) {
            for argument in arguments {
                argument.with(\.leadingTrivia, .newline)
            }
        }

        if isAsync {
            expression = AwaitExprSyntax(expression: expression)
        }

        if isThrowing {
            expression = TryExprSyntax(expression: expression)
        }

        return expression
    }

    /// Returns a `returnValue` variable declaration.
    ///
    /// - Parameter initializerValue: The variable declaration's initializer
    ///   value.
    /// - Returns: A `returnValue` variable declaration.
    private static func returnValueVariableDeclaration(
        initializerValue: any ExprSyntaxProtocol
    ) -> VariableDeclSyntax {
        VariableDeclSyntax(
            .let,
            name: PatternSyntax(
                IdentifierPatternSyntax(identifier: "returnValue")
            ),
            initializer: InitializerClauseSyntax(value: initializerValue)
        )
    }

    /// Returns a guard statement for safely casting a type-erased return value
    /// to its generic type.
    ///
    /// - Parameters:
    ///   - methodName: The name of the method.
    ///   - methodReturnType: The method's return type.
    /// - Returns: A guard statement for safely casting a type-erased return
    ///   value to its generic type.
    private static func genericReturnValueGuardStatement(
        methodName: String,
        methodReturnType: TypeSyntax
    ) -> GuardStmtSyntax {
        GuardStmtSyntax(
            guardKeyword: .keyword(
                .guard,
                trailingTrivia: .newline.appending(.tab)
            ),
            conditions: ConditionElementListSyntax {
                ConditionElementSyntax(
                    condition: .optionalBinding(
                        OptionalBindingConditionSyntax(
                            bindingSpecifier: .keyword(.let),
                            pattern: IdentifierPatternSyntax(
                                identifier: "returnValue"
                            ),
                            initializer: InitializerClauseSyntax(
                                value: AsExprSyntax(
                                    expression: DeclReferenceExprSyntax(
                                        baseName: "returnValue"
                                    ),
                                    questionOrExclamationMark: .postfixQuestionMarkToken(),
                                    type: methodReturnType
                                )
                            )
                        )
                    )
                )
            },
            elseKeyword: .keyword(.else, leadingTrivia: .newline)
        ) {
            FunctionCallExprSyntax(
                calledExpression: DeclReferenceExprSyntax(baseName: "fatalError"),
                leftParen: .leftParenToken(),
                rightParen: .rightParenToken()
            ) {
                LabeledExprSyntax(
                    expression: StringLiteralExprSyntax(
                        openingQuote: .multilineStringQuoteToken(
                            leadingTrivia: .newline.appending(.tab)
                        ),
                        segments: StringLiteralSegmentListSyntax {
                            StringSegmentSyntax(
                                leadingTrivia: .newline.appending(.tab),
                                content: .stringSegment(
                                    "Unable to cast value returned by \\"
                                )
                            )

                            StringSegmentSyntax(
                                leadingTrivia: .newline.appending(.tab),
                                content: .stringSegment("self._\(methodName) \\")
                            )

                            StringSegmentSyntax(
                                leadingTrivia: .newline.appending(.tab),
                                content: .stringSegment("to expected return type \\")
                            )

                            StringSegmentSyntax(
                                leadingTrivia: .newline.appending(.tab),
                                content: .stringSegment("\(methodReturnType).")
                            )
                        },
                        closingQuote: .multilineStringQuoteToken(
                            leadingTrivia: .newline.appending(.tab),
                            trailingTrivia: .newline
                        )
                    )
                )
            }
        }
    }

    /// Returns a `recordOutput` closure call expression.
    ///
    /// - Parameters:
    ///   - backingPropertyAccessExpression: The backing property access
    ///     expression on which to call `recordOutput`.
    ///   - argument: The argument with which to invoke the `recordOutput`
    ///     closure.
    /// - Returns: A `recordOutput` closure call expression.
    private static func recordOutputClosureCallExpression(
        backingPropertyAccessExpression: MemberAccessExprSyntax,
        argument: LabeledExprSyntax
    ) -> FunctionCallExprSyntax {
        FunctionCallExprSyntax(
            calledExpression: MemberAccessExprSyntax(
                base: backingPropertyAccessExpression,
                name: "recordOutput"
            ),
            leftParen: .leftParenToken(),
            rightParen: .rightParenToken(leadingTrivia: .newline)
        ) {
            argument.with(\.leadingTrivia, .newline)
        }
    }

    /// Returns a `recordOutput` closure call argument.
    ///
    /// - Parameters:
    ///   - value: The argument's value.
    ///   - resultTypeCaseName: The name of the `Result` type case that should
    ///     be used if the method is both throwing and returns a value.
    ///   - isMethodThrowingAndReturning: A Boolean value indicating whether the
    ///     method is both throwing and returns a value.
    /// - Returns: A `recordOutput` closure call argument.
    private static func recordOutputClosureCallArgument(
        value: TokenSyntax,
        resultTypeCaseName: TokenSyntax,
        isMethodThrowingAndReturning: Bool
    ) -> LabeledExprSyntax {
        var expression: any ExprSyntaxProtocol = DeclReferenceExprSyntax(
            baseName: value
        )

        if isMethodThrowingAndReturning {
            expression = FunctionCallExprSyntax(
                calledExpression: MemberAccessExprSyntax(
                    name: resultTypeCaseName
                ),
                leftParen: .leftParenToken(),
                rightParen: .rightParenToken()
            ) {
                LabeledExprSyntax(expression: expression)
            }
        }

        return LabeledExprSyntax(expression: expression)
    }

    /// Returns a `throw` statement for `error`.
    ///
    /// - Returns: A `throw` statement for `error`.
    private static func thrownErrorThrowStatement() -> ThrowStmtSyntax {
        ThrowStmtSyntax(
            expression: DeclReferenceExprSyntax(baseName: "error")
        )
    }

    /// Returns a `return` statement for `returnValue`.
    ///
    /// - Returns: A `return` statement for `returnValue`.
    private static func returnValueReturnStatement() -> ReturnStmtSyntax {
        ReturnStmtSyntax(
            expression: DeclReferenceExprSyntax(baseName: "returnValue")
        )
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
