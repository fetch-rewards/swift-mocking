//
//  MockedMacro.swift
//  MockedMacros
//
//  Created by Gray Campbell on 11/4/23.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxSugar

public struct MockedMacro: PeerMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let protocolDeclaration = declaration.as(ProtocolDeclSyntax.self) else {
            throw MockedError.canOnlyBeAppliedToProtocols
        }

        let mock = ClassDeclSyntax(
            modifiers: self.mockModifiers(from: protocolDeclaration),
            classKeyword: .keyword(
                protocolDeclaration.isActorConstrained ? .actor : .class
            ),
            name: self.mockName(from: protocolDeclaration),
            genericParameterClause: self.mockGenericParameterClause(
                from: protocolDeclaration
            ),
            inheritanceClause: self.mockInheritanceClause(
                from: protocolDeclaration
            ),
            genericWhereClause: self.mockGenericWhereClause(
                from: protocolDeclaration
            ),
            memberBlock: try self.mockMemberBlock(from: protocolDeclaration)
        )

        return [DeclSyntax(mock)]
    }
}

// MARK: - Mock

extension MockedMacro {

    // MARK: Name

    /// Returns the type name of the mock.
    private static func mockName(
        from protocolDeclaration: ProtocolDeclSyntax
    ) -> TokenSyntax {
        "\(protocolDeclaration.name.trimmed)Mock"
    }

    // MARK: Modifiers

    /// Returns the modifiers to apply to the mock declaration, including the
    /// minimum access level necessary to conform to the provided protocol.
    ///
    /// ```swift
    /// @Mocked
    /// public protocol Dependency {}
    ///
    /// public final class DependencyMock {}
    /// ```
    ///
    /// - Parameter protocolDeclaration: The protocol to which the mock must
    ///   conform.
    /// - Returns: The modifiers to apply to the mock declaration.
    private static func mockModifiers(
        from protocolDeclaration: ProtocolDeclSyntax
    ) -> DeclModifierListSyntax {
        DeclModifierListSyntax {
            if protocolDeclaration.minimumConformingAccessLevel != .internal {
                protocolDeclaration.minimumConformingAccessLevel.modifier
            }

            DeclModifierSyntax(name: .keyword(.final))
        }
    }

    // MARK: Generic Parameter Clause

    /// Returns the generic parameter clause to apply to the mock declaration,
    /// generated from the associated types defined by the provided protocol.
    ///
    /// ```swift
    /// @Mocked
    /// protocol Dependency {
    ///     associatedtype Item: Equatable, Identifiable
    /// }
    ///
    /// final class DependencyMock<Item: Equatable & Identifiable>: Dependency {}
    /// ```
    ///
    /// - Parameter protocolDeclaration: The protocol to which the mock must
    ///   conform.
    /// - Returns: The generic parameter clause to apply to the mock
    ///   declaration.
    private static func mockGenericParameterClause(
        from protocolDeclaration: ProtocolDeclSyntax
    ) -> GenericParameterClauseSyntax? {
        let associatedTypeDeclarations = protocolDeclaration.associatedTypeDeclarations

        guard !associatedTypeDeclarations.isEmpty else {
            return nil
        }

        return GenericParameterClauseSyntax {
            for associatedTypeDeclaration in associatedTypeDeclarations {
                let genericParameterName = associatedTypeDeclaration.name.trimmed
                let genericInheritedType = associatedTypeDeclaration.inheritanceClause?
                    .inheritedTypes
                    .identifierTypes
                    .map(\.name.text)
                    .joined(separator: " & ")

                if let genericInheritedType {
                    GenericParameterSyntax(
                        name: genericParameterName,
                        colon: .colonToken(),
                        inheritedType: TypeSyntax(stringLiteral: genericInheritedType)
                    )
                } else {
                    GenericParameterSyntax(name: genericParameterName)
                }
            }
        }
    }

    // MARK: Inheritance Clause

    /// Returns the inheritance clause to apply to the mock declaration, which
    /// must conform to the provided protocol.
    ///
    /// ```swift
    /// @Mocked
    /// protocol Dependency {}
    ///
    /// final class DependencyMock: Dependency {}
    /// ```
    ///
    /// - Parameter protocolDeclaration: The protocol to which the mock must
    ///   conform.
    /// - Returns: The inheritance clause to apply to the mock declaration.
    private static func mockInheritanceClause(
        from protocolDeclaration: ProtocolDeclSyntax
    ) -> InheritanceClauseSyntax {
        InheritanceClauseSyntax(
            inheritedTypes: [
                InheritedTypeSyntax(type: protocolDeclaration.type),
            ]
        )
    }

    // MARK: Generic Where Clause

    /// Returns the generic `where` clause to apply to the mock declaration,
    /// generated from the generic `where` clause of the provided protocol and
    /// the generic `where` clauses of the provided protocol's associated types.
    ///
    /// - Parameter protocolDeclaration: The protocol to which the mock must
    ///   conform.
    /// - Returns: The generic `where` clause to apply to the mock declaration.
    private static func mockGenericWhereClause(
        from protocolDeclaration: ProtocolDeclSyntax
    ) -> GenericWhereClauseSyntax? {
        let genericWhereClauses = protocolDeclaration.genericWhereClauses

        guard !genericWhereClauses.isEmpty else {
            return nil
        }

        return GenericWhereClauseSyntax {
            for genericWhereClause in genericWhereClauses {
                for requirement in genericWhereClause.requirements {
                    requirement.trimmed
                }
            }
        }
    }

    // MARK: Members

    /// Returns the member block to apply to the mock, generated from the
    /// variables and methods of the provided protocol.
    ///
    /// - Parameter protocolDeclaration: The protocol to which the mock must
    ///   conform.
    /// - Returns: The member block to apply to the mock.
    private static func mockMemberBlock(
        from protocolDeclaration: ProtocolDeclSyntax
    ) throws -> MemberBlockSyntax {
        try MemberBlockSyntax {
            let accessLevel = protocolDeclaration.minimumConformingAccessLevel
            let variableDeclarations = protocolDeclaration.variableDeclarations
            let methodDeclarations = protocolDeclaration.functionDeclarations

            self.mockDefaultInitializerDeclaration(with: accessLevel)

            for variableDeclaration in variableDeclarations {
                for binding in variableDeclaration.bindings {
                    let variableOverrideDeclarations = self.mockVariableOverrideDeclarations(
                        for: binding,
                        with: accessLevel,
                        in: protocolDeclaration
                    )

                    variableOverrideDeclarations.backingVariable
                    variableOverrideDeclarations.exposedVariable

                    try self.mockVariableConformanceDeclaration(
                        for: binding,
                        with: accessLevel
                    )
                }
            }

            for methodDeclaration in methodDeclarations {
                let methodOverrideDeclarations = self.mockMethodOverrideDeclarations(
                    for: methodDeclaration,
                    with: accessLevel,
                    in: protocolDeclaration
                )

                methodOverrideDeclarations.backingMethod
                methodOverrideDeclarations.exposedMethod

                try self.mockMethodConformanceDeclaration(
                    for: methodDeclaration,
                    with: accessLevel
                )
            }
        }
    }

    /// Returns a default initializer to apply to the mock, with no parameters
    /// and an empty body.
    ///
    /// ```swift
    /// @Mocked
    /// public protocol Dependency {}
    ///
    /// public final class DependencyMock: Dependency {
    ///     public init() {}
    /// }
    /// ```
    ///
    /// - Parameter accessLevel: The access level to apply to the initializer
    ///   declaration.
    /// - Returns: A default initializer to apply to the mock, with no
    ///   parameters and an empty body.
    private static func mockDefaultInitializerDeclaration(
        with accessLevel: AccessLevelSyntax
    ) -> InitializerDeclSyntax {
        InitializerDeclSyntax(
            modifiers: DeclModifierListSyntax {
                if accessLevel != .internal {
                    accessLevel.modifier
                }
            },
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(
                    parameters: FunctionParameterListSyntax()
                )
            )
        ) {}
    }

    /// Returns variable override declarations to apply to the mock, generated
    /// from the provided protocol variable binding with the exposed declaration
    /// marked with the provided access level.
    ///
    /// - Parameters:
    ///   - binding: A variable binding from the protocol to which the mock must
    ///     conform.
    ///   - accessLevel: The access level to apply to the exposed variable
    ///     override declaration.
    /// - Returns: Variable override declarations to apply to the mock.
    private static func mockVariableOverrideDeclarations(
        for binding: PatternBindingSyntax,
        with accessLevel: AccessLevelSyntax,
        in protocolDeclaration: ProtocolDeclSyntax
    ) -> (
        backingVariable: VariableDeclSyntax,
        exposedVariable: VariableDeclSyntax
    ) {
        let mockName = self.mockName(from: protocolDeclaration)
        let variableName = binding.pattern.as(IdentifierPatternSyntax.self)!.identifier
        let backingGenericType = binding.typeAnnotation!.type.trimmed

        var backingType = ""

        if binding.accessorBlock?.containsSetAccessor == true {
            backingType = "MockReadWrite"
        } else {
            backingType = "MockReadOnly"

            if binding.accessorBlock?.getAccessorDeclaration?.isAsync == true {
                backingType += "Async"
            }

            if binding.accessorBlock?.getAccessorDeclaration?.isThrowing == true {
                backingType += "Throwing"
            }
        }

        backingType += "Variable<\(backingGenericType)>"

        return (
            backingVariable: VariableDeclSyntax(
                modifiers: DeclModifierListSyntax {
                    AccessLevelSyntax.private.modifier
                },
                .let,
                name: PatternSyntax(stringLiteral: "__\(variableName)"),
                initializer: InitializerClauseSyntax(
                    value: ExprSyntax(
                        stringLiteral: """
                            \(backingType).makeVariable(
                                exposedVariableDescription: MockImplementationDescription(
                                    type: \(mockName).self,
                                    member: "_\(variableName)"
                                )
                            )
                            """
                    )
                )
            ),
            exposedVariable: VariableDeclSyntax(
                modifiers: DeclModifierListSyntax {
                    if accessLevel != .internal {
                        accessLevel.modifier
                    }
                },
                bindingSpecifier: .keyword(.var),
                bindingsBuilder: {
                    PatternBindingSyntax(
                        pattern: PatternSyntax(stringLiteral: "_\(variableName)"),
                        typeAnnotation: TypeAnnotationSyntax(
                            type: TypeSyntax(stringLiteral: backingType)
                        ),
                        accessorBlock: AccessorBlockSyntax(
                            accessors: .getter(
                                CodeBlockItemListSyntax {
                                    "self.__\(variableName).variable"
                                }
                            )
                        )
                    )
                }
            )
        )
    }

    /// Returns a variable conformance declaration to apply to the mock,
    /// generated from the provided protocol variable binding and marked with
    /// the provided access level.
    ///
    /// - Parameters:
    ///   - binding: A variable binding from the protocol to which the mock must
    ///     conform.
    ///   - accessLevel: The access level to apply to the variable conformance
    ///     declaration.
    /// - Returns: A variable conformance declaration to apply to the mock.
    private static func mockVariableConformanceDeclaration(
        for binding: PatternBindingSyntax,
        with accessLevel: AccessLevelSyntax
    ) throws -> VariableDeclSyntax {
        let variableName = binding.pattern.as(IdentifierPatternSyntax.self)!.identifier

        func getAccessorConformanceDeclaration(
            for getAccessorDeclaration: AccessorDeclSyntax
        ) throws -> AccessorDeclSyntax {
            try getAccessorDeclaration.withBody {
                let getterInvocationKeywordTokens = getAccessorDeclaration.invocationKeywordTokens

                if getterInvocationKeywordTokens.isEmpty {
                    "self.__\(variableName).get()"
                } else {
                    let joinedGetterInvocationKeywordTokens = getterInvocationKeywordTokens
                        .map(\.text)
                        .joined(separator: " ")

                    "\(raw: joinedGetterInvocationKeywordTokens) self.__\(variableName).get()"
                }
            }
        }

        // TODO: Remove default
        let accessors: AccessorBlockSyntax.Accessors = switch (
            binding.accessorBlock?.getAccessorDeclaration,
            binding.accessorBlock?.setAccessorDeclaration
        ) {
        case let (
            .some(getAccessorDeclaration),
            .some(setAccessorDeclaration)
        ):
            .accessors(
                try AccessorDeclListSyntax {
                    try getAccessorConformanceDeclaration(
                        for: getAccessorDeclaration
                    )
                    try setAccessorDeclaration.withBody {
                        "self.__\(variableName).set(newValue)"
                    }
                }
            )
        case let (
            .some(getAccessorDeclaration),
            .none
        ) where getAccessorDeclaration.isAsync || getAccessorDeclaration.isThrowing:
            .accessors(
                try AccessorDeclListSyntax {
                    try getAccessorConformanceDeclaration(
                        for: getAccessorDeclaration
                    )
                }
            )
        default:
            .getter("self.__\(variableName).get()")
        }

        return VariableDeclSyntax(
            modifiers: DeclModifierListSyntax {
                if accessLevel != .internal {
                    accessLevel.modifier
                }
            },
            bindingSpecifier: .keyword(.var),
            bindingsBuilder: {
                PatternBindingSyntax(
                    pattern: binding.pattern,
                    typeAnnotation: binding.typeAnnotation,
                    accessorBlock: AccessorBlockSyntax(accessors: accessors)
                )
            }
        )
    }

    /// Returns method override declarations to apply to the mock, generated
    /// from the provided protocol method with the exposed declaration marked
    /// with the provided access level.
    ///
    /// - Parameters:
    ///   - methodDeclaration: A method from the protocol to which the mock must
    ///     conform.
    ///   - accessLevel: The access level to apply to the exposed method
    ///     override declaration.
    /// - Returns: Method override declarations to apply to the mock.
    private static func mockMethodOverrideDeclarations(
        for methodDeclaration: FunctionDeclSyntax,
        with accessLevel: AccessLevelSyntax,
        in protocolDeclaration: ProtocolDeclSyntax
    ) -> (
        backingMethod: VariableDeclSyntax,
        exposedMethod: VariableDeclSyntax
    ) {
        let mockName = self.mockName(from: protocolDeclaration)
        let methodName = methodDeclaration.name
        let methodSignature = methodDeclaration.signature
        let methodParameters = methodSignature.parameterClause.parameters

        var backingType: String
        var backingGenericArguments: [String] = []

        if let returnClause = methodSignature.returnClause {
            backingType = "MockReturning"
            backingGenericArguments.append(returnClause.type.trimmedDescription)
        } else {
            backingType = "MockVoid"
        }

        if methodDeclaration.isAsync {
            backingType += "Async"
        }

        if methodDeclaration.isThrowing {
            backingType += "Throwing"
        }

        backingType += "Method"

        if let arguments = methodParameters.toTupleTypeSyntax() {
            backingType += "WithParameters"
            backingGenericArguments.insert(arguments.trimmedDescription, at: .zero)
        } else {
            backingType += "WithoutParameters"
        }

        if !backingGenericArguments.isEmpty {
            backingType += "<\(backingGenericArguments.joined(separator: ", "))>"
        }

        let backingMethodInitializerValue = if methodSignature.returnClause == nil {
            "\(backingType).makeMethod()"
        } else {
            """
            \(backingType).makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: \(mockName).self,
                    member: "_\(methodName)"
                )
            )
            """
        }

        return (
            backingMethod: VariableDeclSyntax(
                modifiers: DeclModifierListSyntax {
                    AccessLevelSyntax.private.modifier
                },
                .let,
                name: PatternSyntax(
                    stringLiteral: "__\(methodName)"
                ),
                initializer: InitializerClauseSyntax(
                    value: ExprSyntax(stringLiteral: backingMethodInitializerValue)
                )
            ),
            exposedMethod: VariableDeclSyntax(
                modifiers: DeclModifierListSyntax {
                    if accessLevel != .internal {
                        accessLevel.modifier
                    }
                },
                bindingSpecifier: .keyword(.var),
                bindingsBuilder: {
                    PatternBindingSyntax(
                        pattern: PatternSyntax(stringLiteral: "_\(methodName)"),
                        typeAnnotation: TypeAnnotationSyntax(
                            type: TypeSyntax(stringLiteral: backingType)
                        ),
                        accessorBlock: AccessorBlockSyntax(
                            accessors: .getter(
                                CodeBlockItemListSyntax {
                                    "self.__\(methodName).method"
                                }
                            )
                        )
                    )
                }
            )
        )
    }

    /// Returns a method conformance declaration to apply to the mock, generated
    /// from the provided protocol method and marked with the provided access
    /// level.
    ///
    /// - Parameters:
    ///   - methodDeclaration: A method from the protocol to which the mock must
    ///     conform.
    ///   - accessLevel: The access level to apply to the method conformance
    ///     declaration.
    /// - Returns: A method conformance declaration to apply to the mock.
    private static func mockMethodConformanceDeclaration(
        for methodDeclaration: FunctionDeclSyntax,
        with accessLevel: AccessLevelSyntax
    ) throws -> FunctionDeclSyntax {
        let methodName = methodDeclaration.name.trimmed
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
                .map(\.text)
                .joined(separator: ", ")

            backingImplementationInvocation += "((\(joinedInvocationArguments)))"
        }

        return try methodDeclaration
            .trimmed
            .withAccessLevel(accessLevel)
            .withBody {
                CodeBlockItemSyntax(stringLiteral: backingImplementationInvocation)
            }
    }
}
