//
//  MockedMethodMacro+PeerMacro.swift
//
//  Copyright © 2025 Fetch.
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

        var peers: [DeclSyntax] = []

        let macroArguments = try MacroArguments(node: node)
        let implementationTypes = self.implementationTypes(
            from: methodDeclaration
        )
        let overrideDeclarationTypeName = self.overrideDeclarationTypeName(
            from: methodDeclaration
        )

        var implementationTypeName: TokenSyntax?

        if let closureType = implementationTypes.closureType {
            let implementationDeclaration = self.implementationDeclaration(
                macroArguments: macroArguments,
                methodDeclaration: methodDeclaration,
                returnValueType: implementationTypes.returnValueType,
                closureType: closureType,
                overrideDeclarationTypeName: overrideDeclarationTypeName
            )

            peers.append(DeclSyntax(implementationDeclaration))
            implementationTypeName = implementationDeclaration.name
        }

        let overrideDeclarationType = self.overrideDeclarationType(
            named: overrideDeclarationTypeName,
            methodDeclaration: methodDeclaration,
            argumentsType: implementationTypes.argumentsType,
            returnValueType: implementationTypes.returnValueType,
            implementationTypeName: implementationTypeName
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

        peers.append(DeclSyntax(backingOverrideDeclaration))
        peers.append(DeclSyntax(exposedOverrideDeclaration))

        return peers
    }

    // MARK: Implementation Declaration

    /// Returns the types to apply to the implementation declaration for the
    /// provided `methodDeclaration`.
    ///
    /// - Parameter methodDeclaration: The method declaration from which to
    ///   parse the types to apply to the implementation declaration.
    /// - Returns: The types to apply to the implementation declaration for the
    ///   provided `methodDeclaration`
    private static func implementationTypes(
        from methodDeclaration: FunctionDeclSyntax
    ) -> (
        argumentsType: TupleTypeSyntax?,
        returnValueType: TypeSyntax?,
        closureType: FunctionTypeSyntax?
    ) {
        let signature = methodDeclaration.signature
        let parameters = signature.parameterClause.parameters
        let genericParameterClause = methodDeclaration.genericParameterClause

        var argumentsTypeElements: [TupleTypeElementSyntax] = []
        var closureTypeElements: [TupleTypeElementSyntax] = []

        if !parameters.isEmpty {
            for (index, parameter) in parameters.enumerated() {
                let (parameterType, didTypeEraseParameter) = self.type(
                    parameter.type,
                    typeErasedIfNecessaryUsing: genericParameterClause?.parameters,
                    typeConstrainedBy: methodDeclaration.genericWhereClause
                )

                let attributedType = parameterType.as(AttributedTypeSyntax.self)
                let unattributedType = attributedType?.baseType ?? parameterType
                let argumentsTypeElementType: any TypeSyntaxProtocol
                let closureTypeElementType: any TypeSyntaxProtocol

                if parameter.isVariadic {
                    argumentsTypeElementType = ArrayTypeSyntax(
                        element: unattributedType
                    )
                    closureTypeElementType = ArrayTypeSyntax(
                        element: didTypeEraseParameter
                            ? unattributedType
                            : parameterType
                    )
                } else {
                    argumentsTypeElementType = unattributedType
                    closureTypeElementType = didTypeEraseParameter
                        ? unattributedType
                        : parameterType
                }

                let isLastParameter = index == parameters.count - 1
                let trailingComma: TokenSyntax? = isLastParameter
                    ? nil
                    : .commaToken()

                let argumentsTypeElement = if parameters.count == 1 {
                    TupleTypeElementSyntax(
                        type: argumentsTypeElementType,
                        trailingComma: trailingComma
                    )
                } else {
                    TupleTypeElementSyntax(
                        firstName: parameter.secondName ?? parameter.firstName,
                        colon: .colonToken(),
                        type: argumentsTypeElementType,
                        trailingComma: trailingComma
                    )
                }
                let closureTypeElement = TupleTypeElementSyntax(
                    type: closureTypeElementType,
                    trailingComma: trailingComma
                )

                argumentsTypeElements.append(argumentsTypeElement)
                closureTypeElements.append(closureTypeElement)
            }
        }

        var argumentsType: TupleTypeSyntax?
        var returnValueType: TypeSyntax?
        var closureType: FunctionTypeSyntax?

        if !argumentsTypeElements.isEmpty {
            argumentsType = TupleTypeSyntax(
                elements: TupleTypeElementListSyntax(argumentsTypeElements)
            )
        }

        if let returnClause = signature.returnClause {
            (returnValueType, _) = self.type(
                returnClause.type.trimmed,
                typeErasedIfNecessaryUsing: genericParameterClause?.parameters,
                typeConstrainedBy: methodDeclaration.genericWhereClause
            )
        }

        if !closureTypeElements.isEmpty {
            closureType = FunctionTypeSyntax(
                parameters: TupleTypeElementListSyntax(closureTypeElements),
                effectSpecifiers: TypeEffectSpecifiersSyntax(
                    asyncSpecifier: signature.effectSpecifiers?.asyncSpecifier,
                    throwsClause: signature.effectSpecifiers?.throwsClause
                ),
                returnClause: ReturnClauseSyntax(
                    type: returnValueType == nil
                        ? TypeSyntax.void
                        : "ReturnValue"
                )
            )
        }

        return (
            argumentsType,
            returnValueType,
            closureType
        )
    }

    /// Returns an implementation declaration for the provided
    /// `methodDeclaration`.
    ///
    /// - Parameters:
    ///   - macroArguments: The arguments passed to the macro.
    ///   - methodDeclaration: The method declaration to which the macro is
    ///     attached.
    ///   - returnValueType: The implementation's `ReturnValue` type, or `nil`
    ///     if there isn't one.
    ///   - closureType: The implementation's `Closure` type.
    ///   - overrideDeclarationTypeName: The name of the override declarations'
    ///     type.
    /// - Returns: An implementation declaration for the provided
    ///   `methodDeclaration`.
    private static func implementationDeclaration(
        macroArguments: MacroArguments,
        methodDeclaration: FunctionDeclSyntax,
        returnValueType: TypeSyntax?,
        closureType: FunctionTypeSyntax,
        overrideDeclarationTypeName: String
    ) -> EnumDeclSyntax {
        let modifiers = DeclModifierListSyntax {
            if methodDeclaration.accessLevel != .internal {
                methodDeclaration.accessLevel.modifier
            }
        }

        return EnumDeclSyntax(
            leadingTrivia: """
            /// An implementation for \
            `\(macroArguments.mockName)._\(macroArguments.mockMethodName)`.\n
            """,
            modifiers: modifiers,
            name: .identifier(
                macroArguments.mockMethodName
                    .withFirstCharacterCapitalized()
                    .appending("Implementation")
            ),
            genericParameterClause: GenericParameterClauseSyntax {
                GenericParameterSyntax(
                    leadingTrivia: .newline.appending(.tab),
                    name: "Arguments",
                    trailingComma: returnValueType == nil ? nil : .commaToken(),
                    trailingTrivia: .newline
                )

                if returnValueType != nil {
                    GenericParameterSyntax(
                        leadingTrivia: .tab,
                        name: "ReturnValue",
                        trailingTrivia: .newline
                    )
                }
            },
            inheritanceClause: InheritanceClauseSyntax {
                // @unchecked Sendable
                .uncheckedSendable

                // Implementation
                InheritedTypeSyntax(
                    type: IdentifierTypeSyntax(
                        name: .identifier(
                            overrideDeclarationTypeName + "Implementation"
                        )
                    )
                )
            }
        ) {
            // typealias Closure
            TypeAliasDeclSyntax(
                leadingTrivia: "\n\n/// The implementation's closure type.\n",
                modifiers: modifiers,
                name: "Closure",
                initializer: TypeInitializerClauseSyntax(value: closureType)
            )

            // case unimplemented
            EnumCaseDeclSyntax(
                leadingTrivia: returnValueType == nil
                    ? "\n\n/// Does nothing when invoked.\n"
                    : "\n\n/// Triggers a fatal error when invoked.\n"
            ) {
                EnumCaseElementSyntax(name: "unimplemented")
            }

            // case uncheckedInvokes
            EnumCaseDeclSyntax(
                leadingTrivia: """
                \n
                /// Invokes the provided closure when invoked.
                ///
                /// - Parameter closure: The closure to invoke.\n
                """
            ) {
                EnumCaseElementSyntax(
                    name: "uncheckedInvokes",
                    parameterClause: EnumCaseParameterClauseSyntax(
                        parameters: EnumCaseParameterListSyntax {
                            EnumCaseParameterSyntax(
                                firstName: .wildcardToken(),
                                secondName: "closure",
                                type: IdentifierTypeSyntax(name: "Closure")
                            )
                        }
                    )
                )
            }

            // static func invokes(_ closure: @Sendable @escaping ...) -> Self { ... }
            self.implementationConstructor(
                leadingTrivia: """
                \n
                /// Invokes the provided closure when invoked.
                ///
                /// - Parameter closure: The closure to invoke.\n
                """,
                modifiers: modifiers,
                name: "invokes",
                parameterName: "closure",
                parameterType: AttributedTypeSyntax(
                    specifiers: [],
                    attributes: AttributeListSyntax {
                        AttributeSyntax(
                            attributeName: IdentifierTypeSyntax(
                                name: "Sendable"
                            )
                        )

                        AttributeSyntax(
                            attributeName: IdentifierTypeSyntax(
                                name: "escaping"
                            )
                        )
                    },
                    baseType: closureType
                ),
                genericWhereClause: GenericWhereClauseSyntax {
                    GenericRequirementSyntax(
                        requirement: .conformanceRequirement(
                            ConformanceRequirementSyntax(
                                leftType: IdentifierTypeSyntax(name: "Arguments"),
                                rightType: IdentifierTypeSyntax(name: "Sendable")
                            )
                        ),
                        trailingComma: returnValueType == nil ? nil : .commaToken()
                    )

                    if returnValueType != nil {
                        GenericRequirementSyntax(
                            requirement: .conformanceRequirement(
                                ConformanceRequirementSyntax(
                                    leftType: IdentifierTypeSyntax(name: "ReturnValue"),
                                    rightType: IdentifierTypeSyntax(name: "Sendable")
                                )
                            )
                        )
                    }
                }
            ) {
                ".uncheckedInvokes(closure)"
            }

            if methodDeclaration.isThrowing {
                // static func `throws`(_ error: Error) -> Self { ... }
                self.implementationConstructor(
                    leadingTrivia: """
                    \n
                    /// Throws the provided error when invoked.
                    ///
                    /// - Parameter error: The error to throw.\n
                    """,
                    modifiers: modifiers,
                    name: "`throws`",
                    parameterName: "error",
                    parameterType: SomeOrAnyTypeSyntax(
                        someOrAnySpecifier: .keyword(.any),
                        constraint: IdentifierTypeSyntax(name: "Error")
                    )
                ) {
                    self.implementationFunctionCallExpression(
                        closureParameterCount: closureType.parameters.count
                    ) {
                        "throw error"
                    }
                }
            }

            if returnValueType != nil {
                // static func uncheckedReturns(_ returnValue: ReturnValue) -> Self { ... }
                self.implementationConstructor(
                    leadingTrivia: """
                    \n
                    /// Returns the provided value when invoked.
                    ///
                    /// - Parameter value: The value to return.\n
                    """,
                    modifiers: modifiers,
                    name: "uncheckedReturns",
                    parameterName: "value",
                    parameterType: IdentifierTypeSyntax(name: "ReturnValue")
                ) {
                    self.implementationFunctionCallExpression(
                        closureParameterCount: closureType.parameters.count
                    ) {
                        "value"
                    }
                }

                // static func returns(_ returnValue: ReturnValue) -> Self { ... }
                self.implementationConstructor(
                    leadingTrivia: """
                    \n
                    /// Returns the provided value when invoked.
                    ///
                    /// - Parameter value: The value to return.\n
                    """,
                    modifiers: modifiers,
                    name: "returns",
                    parameterName: "value",
                    parameterType: IdentifierTypeSyntax(name: "ReturnValue"),
                    genericWhereClause: GenericWhereClauseSyntax {
                        GenericRequirementSyntax(
                            requirement: .conformanceRequirement(
                                ConformanceRequirementSyntax(
                                    leftType: IdentifierTypeSyntax(name: "ReturnValue"),
                                    rightType: IdentifierTypeSyntax(name: "Sendable")
                                )
                            )
                        )
                    }
                ) {
                    self.implementationFunctionCallExpression(
                        closureParameterCount: closureType.parameters.count
                    ) {
                        "value"
                    }
                }
            }

            // var _closure: Closure? { ... }
            VariableDeclSyntax(
                leadingTrivia: """
                \n
                /// The implementation as a closure, or `nil` if unimplemented.\n
                """,
                modifiers: modifiers,
                bindingSpecifier: .keyword(.var)
            ) {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: "_closure"),
                    typeAnnotation: TypeAnnotationSyntax(
                        type: OptionalTypeSyntax(
                            wrappedType: IdentifierTypeSyntax(name: "Closure")
                        )
                    ),
                    accessorBlock: AccessorBlockSyntax(
                        accessors: .getter(
                            CodeBlockItemListSyntax {
                                """
                                switch self {
                                case .unimplemented:
                                    nil
                                case let .uncheckedInvokes(closure):
                                    closure
                                }
                                """
                            }
                        )
                    )
                )
            }
        }
    }

    /// Returns a constructor function declaration for an implementation.
    ///
    /// - Parameters:
    ///   - leadingTrivia: The constructor function's leading trivia.
    ///   - modifiers: The constructor function's modifiers.
    ///   - name: The constructor function's name.
    ///   - parameterName: The constructor function's parameter name.
    ///   - parameterType: The constructor function's parameter type.
    ///   - genericWhereClause: The constructor function's generic where clause.
    ///   - bodyBuilder: The constructor function's body.
    /// - Returns: A construction function declaration for an implementation.
    private static func implementationConstructor(
        leadingTrivia: Trivia,
        modifiers: DeclModifierListSyntax,
        name: TokenSyntax,
        parameterName: TokenSyntax,
        parameterType: some TypeSyntaxProtocol,
        genericWhereClause: GenericWhereClauseSyntax? = nil,
        @CodeBlockItemListBuilder bodyBuilder: () -> CodeBlockItemListSyntax
    ) -> FunctionDeclSyntax {
        FunctionDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: DeclModifierListSyntax {
                for modifier in modifiers {
                    modifier
                }

                DeclModifierSyntax(name: .keyword(.static))
            },
            name: name,
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax {
                    FunctionParameterSyntax(
                        leadingTrivia: .newline.appending(.tab),
                        firstName: .wildcardToken(),
                        secondName: parameterName,
                        type: parameterType,
                        trailingTrivia: .newline
                    )
                },
                returnClause: ReturnClauseSyntax(
                    type: IdentifierTypeSyntax(name: "Self")
                )
            ),
            genericWhereClause: genericWhereClause,
            bodyBuilder: bodyBuilder
        )
    }

    /// Returns a function call expression for an implementation.
    ///
    /// - Parameters:
    ///   - closureParameterCount: The number of parameters to apply to the
    ///     function call expression's trailing closure.
    ///   - closureStatementsBuilder: The closure statements to apply to the
    ///     function call expression's trailing closure.
    /// - Returns: A function call expression for an implementation.
    private static func implementationFunctionCallExpression(
        closureParameterCount: Int,
        @CodeBlockItemListBuilder closureStatementsBuilder: () -> CodeBlockItemListSyntax
    ) -> FunctionCallExprSyntax {
        FunctionCallExprSyntax(
            calledExpression: MemberAccessExprSyntax(name: "uncheckedInvokes"),
            arguments: [],
            trailingClosure: ClosureExprSyntax(
                signature: ClosureSignatureSyntax(
                    parameterClause: .simpleInput(
                        ClosureShorthandParameterListSyntax {
                            for index in 0..<closureParameterCount {
                                ClosureShorthandParameterSyntax(
                                    name: .wildcardToken(),
                                    trailingComma: index == closureParameterCount - 1
                                        ? nil
                                        : .commaToken()
                                )
                            }
                        }
                    )
                ),
                statementsBuilder: closureStatementsBuilder
            )
        )
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
        let name = macroArguments.mockMethodName
        let modifiers = self.overrideDeclarationModifiers(
            from: methodDeclaration.modifiers,
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
        let name = macroArguments.mockMethodName
        let modifiers = self.overrideDeclarationModifiers(
            from: methodDeclaration.modifiers,
            with: methodDeclaration.accessLevel,
            isMockAnActor: macroArguments.isMockAnActor
        )
        let binding = PatternBindingSyntax(
            pattern: IdentifierPatternSyntax(identifier: "_\(raw: name)"),
            typeAnnotation: TypeAnnotationSyntax(type: overrideDeclarationType),
            accessorBlock: AccessorBlockSyntax(
                accessors: .getter(
                    CodeBlockItemListSyntax {
                        "self.__\(raw: name).method"
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

    /// Returns the name of the type to apply to override declarations for the
    /// provided `methodDeclaration`.
    ///
    /// - Parameter methodDeclaration: The method declaration for which to
    ///   determine the override declaration type name.
    /// - Returns: The name of the type to apply to override declarations for
    ///   the provided `methodDeclaration`.
    private static func overrideDeclarationTypeName(
        from methodDeclaration: FunctionDeclSyntax
    ) -> String {
        var name = "Mock"

        if methodDeclaration.signature.returnClause == nil {
            name += "Void"
        } else {
            name += "Returning"
        }

        if methodDeclaration.signature.parameterClause.parameters.isEmpty {
            name += "NonParameterized"
        } else {
            name += "Parameterized"
        }

        if methodDeclaration.isAsync {
            name += "Async"
        }

        if methodDeclaration.isThrowing {
            name += "Throwing"
        }

        name += "Method"

        return name
    }

    /// Returns the type to apply to override declarations for the provided
    /// `methodDeclaration`.
    ///
    /// - Parameters:
    ///   - name: The override declaration type's name.
    ///   - methodDeclaration: The method declaration for which to determine the
    ///     override declaration type.
    ///   - argumentsType: The arguments type.
    ///   - returnValueType: The return value type, or `nil` if there isn't one.
    ///   - implementationTypeName: The implementation type name, or `nil` if
    ///     there isn't one.
    /// - Returns: The type to apply to override declarations for the provided
    ///   `methodDeclaration`.
    private static func overrideDeclarationType(
        named name: String,
        methodDeclaration: FunctionDeclSyntax,
        argumentsType: TupleTypeSyntax?,
        returnValueType: TypeSyntax?,
        implementationTypeName: TokenSyntax?
    ) -> IdentifierTypeSyntax {
        let parameters = methodDeclaration.signature.parameterClause.parameters

        var genericArgumentClause: GenericArgumentClauseSyntax?

        if parameters.isEmpty, let returnValueType {
            genericArgumentClause = GenericArgumentClauseSyntax {
                GenericArgumentSyntax(
                    leadingTrivia: .newline.appending(.tab),
                    argument: returnValueType,
                    trailingTrivia: .newline
                )
            }
        } else if !parameters.isEmpty, let implementationTypeName, let argumentsType {
            genericArgumentClause = GenericArgumentClauseSyntax {
                GenericArgumentSyntax(
                    leadingTrivia: .newline.appending(.tab),
                    argument: IdentifierTypeSyntax(
                        name: implementationTypeName,
                        genericArgumentClause: GenericArgumentClauseSyntax {
                            GenericArgumentSyntax(
                                leadingTrivia: .newline.appending(.tab).appending(.tab),
                                argument: argumentsType,
                                trailingComma: returnValueType == nil
                                    ? nil
                                    : .commaToken(),
                                trailingTrivia: .newline.appending(.tab)
                            )

                            if let returnValueType {
                                GenericArgumentSyntax(
                                    leadingTrivia: .tab,
                                    argument: returnValueType,
                                    trailingTrivia: .newline.appending(.tab)
                                )
                            }
                        }
                    ),
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
