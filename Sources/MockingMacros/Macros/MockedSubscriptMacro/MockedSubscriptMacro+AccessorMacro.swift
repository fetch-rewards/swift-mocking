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

        let genericParameters = subscriptDeclaration.genericParameterClause?.parameters
        let genericWhereClause = subscriptDeclaration.genericWhereClause
        let returnType = subscriptDeclaration.returnClause.type.trimmed
        let didTypeEraseReturnType = MockedMethodMacro.type(
            returnType,
            typeErasedIfNecessaryUsing: genericParameters,
            typeConstrainedBy: genericWhereClause
        ).didTypeErase

        var accessors: [AccessorDeclSyntax] = [
            self.getAccessor(
                subscriptName: subscriptName,
                keyArgument: keyArgument,
                returnType: didTypeEraseReturnType ? returnType : nil,
                subscriptType: macroArguments.subscriptType
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
    /// `subscriptName`, `keyArgument`, `returnType`, and `subscriptType`.
    ///
    /// - Parameters:
    ///   - subscriptName: The disambiguated name of the mock subscript backing.
    ///   - keyArgument: The key argument expression to pass to `get(_:)`.
    ///   - returnType: The original return type of the subscript, or `nil` if
    ///     the return type does not involve generic type parameters. When
    ///     non-nil, a guard cast statement is generated to safely cast the
    ///     type-erased return value to the concrete return type.
    ///   - subscriptType: The type of subscript being mocked.
    /// - Returns: A `get` accessor.
    private static func getAccessor(
        subscriptName: String,
        keyArgument: ExprSyntax,
        returnType: TypeSyntax?,
        subscriptType: MockedSubscriptType
    ) -> AccessorDeclSyntax {
        var asyncSpecifier: TokenSyntax?
        var throwsClause: ThrowsClauseSyntax?
        var getterInvocationExpression: any ExprSyntaxProtocol

        getterInvocationExpression = FunctionCallExprSyntax(
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

        if case .async = subscriptType.getterAsyncSpecifier {
            asyncSpecifier = .keyword(.async)
            getterInvocationExpression = AwaitExprSyntax(
                awaitKeyword: .keyword(.await),
                expression: getterInvocationExpression
            )
        }

        if case .throws = subscriptType.getterThrowsSpecifier {
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
        case (_, .some), (.some, _):
            AccessorEffectSpecifiersSyntax(
                asyncSpecifier: asyncSpecifier,
                throwsClause: throwsClause
            )
        case (.none, .none):
            nil
        }

        if let returnType {
            return AccessorDeclSyntax(
                accessorSpecifier: .keyword(.get),
                effectSpecifiers: effectSpecifiers
            ) {
                VariableDeclSyntax(
                    .let,
                    name: PatternSyntax(
                        IdentifierPatternSyntax(identifier: "returnValue")
                    ),
                    initializer: InitializerClauseSyntax(value: getterInvocationExpression)
                )
                self.genericReturnValueGuardStatement(
                    subscriptName: subscriptName,
                    returnType: returnType
                )
                ReturnStmtSyntax(
                    expression: DeclReferenceExprSyntax(baseName: "returnValue")
                )
            }
        } else {
            return AccessorDeclSyntax(
                accessorSpecifier: .keyword(.get),
                effectSpecifiers: effectSpecifiers
            ) {
                getterInvocationExpression
            }
        }
    }

    // MARK: Generic Return Value Guard Statement

    /// Returns a guard statement for safely casting a type-erased subscript
    /// return value to its generic type.
    ///
    /// - Parameters:
    ///   - subscriptName: The disambiguated name of the mock subscript backing.
    ///   - returnType: The subscript's return type.
    /// - Returns: A guard statement for safely casting a type-erased return
    ///   value to its generic type.
    private static func genericReturnValueGuardStatement(
        subscriptName: String,
        returnType: TypeSyntax
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
                                    type: returnType
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
                                content: .stringSegment("self._\(subscriptName) \\")
                            )

                            StringSegmentSyntax(
                                leadingTrivia: .newline.appending(.tab),
                                content: .stringSegment("to expected return type \\")
                            )

                            StringSegmentSyntax(
                                leadingTrivia: .newline.appending(.tab),
                                content: .stringSegment("\(returnType).")
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
