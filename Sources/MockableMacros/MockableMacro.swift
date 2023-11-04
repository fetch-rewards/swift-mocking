//
//  MockableMacro.swift
//  MockableMacros
//
//  Created by Gray Campbell on 11/4/23.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxSugar

public struct MockableMacro: PeerMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let protocolDeclaration = declaration.as(ProtocolDeclSyntax.self)
        else {
            throw MockableError.canOnlyBeAppliedToProtocols
        }

        let mock = ClassDeclSyntax(
            modifiers: self.mockModifiers(from: protocolDeclaration),
            classKeyword: .keyword(
                protocolDeclaration.isActorConstrained ? .actor : .class
            ),
            name: "\(protocolDeclaration.name.trimmed)Mock",
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

extension MockableMacro {

    // MARK: Modifiers

    /// Returns the modifiers to apply to the mock declaration, including the
    /// minimum access level necessary to conform to the provided protocol.
    ///
    /// ```swift
    /// @Mockable
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
    /// @Mockable
    /// protocol Dependency {
    ///     associatedtype Item: Equatable, Identifiable
    /// }
    ///
    /// final class DependencyMock<Item: Equatable & Identifiable> {}
    /// ```
    ///
    /// - Parameter protocolDeclaration: The protocol to which the mock must
    ///   conform.
    /// - Returns: The generic parameter clause to apply to the mock
    ///   declaration.
    private static func mockGenericParameterClause(
        from protocolDeclaration: ProtocolDeclSyntax
    ) -> GenericParameterClauseSyntax? {
        let associatedTypeDeclarations =
            protocolDeclaration.associatedTypeDeclarations

        guard !associatedTypeDeclarations.isEmpty else {
            return nil
        }

        return GenericParameterClauseSyntax {
            for associatedTypeDeclaration in associatedTypeDeclarations {
                let name = associatedTypeDeclaration.name.trimmed

                if let associatedTypeInheritanceClause =
                    associatedTypeDeclaration.inheritanceClause
                {
                    GenericParameterSyntax(
                        name: name,
                        colon: .colonToken(),
                        inheritedType: TypeSyntax(
                            stringLiteral: associatedTypeInheritanceClause
                                .inheritedTypes
                                .identifierTypes
                                .map(\.name.text)
                                .joined(separator: " & ")
                        )
                    )
                } else {
                    GenericParameterSyntax(name: name)
                }
            }
        }
    }

    // MARK: Inheritance Clause

    /// Returns the inheritance clause to apply to the mock declaration, which
    /// must conform to the provided protocol.
    ///
    /// - Parameter protocolDeclaration: The protocol to which the mock must
    ///   conform.
    /// - Returns: The inheritance clause to apply to the mock declaration.
    private static func mockInheritanceClause(
        from protocolDeclaration: ProtocolDeclSyntax
    ) -> InheritanceClauseSyntax {
        InheritanceClauseSyntax(
            inheritedTypes: [
                InheritedTypeSyntax(type: protocolDeclaration.type)
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
    /// variables and functions of the provided protocol.
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
            let functionDeclarations = protocolDeclaration.functionDeclarations

            self.mockDefaultInitializerDeclaration(with: accessLevel)

            for variableDeclaration in variableDeclarations {
                for binding in variableDeclaration.bindings {
                    self.mockVariableOverrideDeclaration(
                        for: binding,
                        with: accessLevel
                    )
                    try self.mockVariableConformanceDeclaration(
                        for: binding,
                        with: accessLevel
                    )
                }
            }

            for functionDeclaration in functionDeclarations {
                self.mockFunctionOverrideDeclaration(
                    for: functionDeclaration,
                    with: accessLevel
                )
                try self.mockFunctionConformanceDeclaration(
                    for: functionDeclaration,
                    with: accessLevel
                )
            }
        }
    }

    /// Returns a default initializer to apply to the mock, with no parameters
    /// and an empty body.
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

    /// Returns a variable override declaration to apply to the mock, generated
    /// from the provided protocol variable binding and marked with the provided
    /// access level.
    ///
    /// - Parameters:
    ///   - binding: A variable binding from the protocol to which the mock must
    ///     conform.
    ///   - accessLevel: The access level to apply to the variable override
    ///     declaration.
    /// - Returns: A variable override declaration to apply to the mock.
    private static func mockVariableOverrideDeclaration(
        for binding: PatternBindingSyntax,
        with accessLevel: AccessLevelSyntax
    ) -> VariableDeclSyntax {
        let name = binding.pattern.as(IdentifierPatternSyntax.self)!.identifier
        let type = binding.typeAnnotation!.type.trimmed
        let accessorBlock = binding.accessorBlock

        var typeName = ""

        if accessorBlock?.containsSetAccessor == true {
            typeName = "MockReadWrite"
        } else {
            typeName = "MockReadOnly"

            if accessorBlock?.getAccessorDeclaration?.isAsync == true {
                typeName += "Async"
            }

            if accessorBlock?.getAccessorDeclaration?.isThrowing == true {
                typeName += "Throwing"
            }
        }

        typeName += "Variable"

        return VariableDeclSyntax(
            modifiers: DeclModifierListSyntax {
                if accessLevel != .internal {
                    accessLevel.modifier
                }
            },
            .var,
            name: PatternSyntax(stringLiteral: "_\(name)"),
            initializer: InitializerClauseSyntax(
                value: ExprSyntax(stringLiteral: "\(typeName)<\(type)>()")
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
        let name = binding.pattern.as(IdentifierPatternSyntax.self)!.identifier
        let getAccessorConformanceDeclaration: (
            AccessorDeclSyntax
        ) throws -> AccessorDeclSyntax = { getAccessorDeclaration in
            try getAccessorDeclaration.withBody {
                if let invocationKeywordTokens =
                    getAccessorDeclaration.invocationKeywordTokens
                {
                    let joinedInvocationKeywordTokens =
                        invocationKeywordTokens
                            .map(\.text)
                            .joined(separator: " ")

                    "\(raw: joinedInvocationKeywordTokens) self._\(name).getter.get()"
                } else {
                    "self._\(name).getter.get()"
                }
            }
        }

        // TODO: Remove default
        let accessors: AccessorBlockSyntax.Accessors =
            switch (
                binding.accessorBlock?.getAccessorDeclaration,
                binding.accessorBlock?.setAccessorDeclaration
            ) {
            case (
                .some(let getAccessorDeclaration),
                .some(let setAccessorDeclaration)
            ):
                .accessors(
                    try AccessorDeclListSyntax {
                        try getAccessorConformanceDeclaration(
                            getAccessorDeclaration
                        )
                        try setAccessorDeclaration.withBody {
                            "self._\(name).setter.set(newValue)"
                        }
                    }
                )
            case (
                .some(let getAccessorDeclaration),
                .none
            )
            where getAccessorDeclaration.isAsync
                || getAccessorDeclaration.isThrowing:
                .accessors(
                    try AccessorDeclListSyntax {
                        try getAccessorConformanceDeclaration(
                            getAccessorDeclaration
                        )
                    }
                )
            default:
                .getter("self._\(name).getter.get()")
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

    /// Returns a function override declaration to apply to the mock, generated
    /// from the provided protocol function and marked with the provided access
    /// level.
    ///
    /// - Parameters:
    ///   - functionDeclaration: A function from the protocol to which the mock
    ///     must conform.
    ///   - accessLevel: The access level to apply to the function override
    ///     declaration.
    /// - Returns: A function override declaration to apply to the mock.
    private static func mockFunctionOverrideDeclaration(
        for functionDeclaration: FunctionDeclSyntax,
        with accessLevel: AccessLevelSyntax
    ) -> VariableDeclSyntax {
        let functionSignature = functionDeclaration.signature
        let functionParameters = functionSignature.parameterClause.parameters

        var initializerValue: String
        var genericArguments: [String] = []

        if let returnClause = functionSignature.returnClause {
            initializerValue = "MockReturning"
            genericArguments.append(returnClause.type.trimmedDescription)
        } else {
            initializerValue = "MockVoid"
        }

        if functionDeclaration.isAsync {
            initializerValue += "Async"
        }

        if functionDeclaration.isThrowing {
            initializerValue += "Throwing"
        }

        initializerValue += "Function"

        if let arguments = functionParameters.toTupleTypeSyntax() {
            initializerValue += "WithParameters"
            genericArguments.insert(arguments.trimmedDescription, at: .zero)
        } else {
            initializerValue += "WithoutParameters"
        }

        if !genericArguments.isEmpty {
            initializerValue +=
                "<\(genericArguments.joined(separator: ", "))>()"
        }

        return VariableDeclSyntax(
            modifiers: DeclModifierListSyntax {
                if accessLevel != .internal {
                    accessLevel.modifier
                }
            },
            .var,
            name: PatternSyntax(stringLiteral: "_\(functionDeclaration.name)"),
            initializer: InitializerClauseSyntax(
                value: ExprSyntax(stringLiteral: initializerValue)
            )
        )
    }

    /// Returns a function conformance declaration to apply to the mock,
    /// generated from the provided protocol function and marked with the
    /// provided access level.
    ///
    /// - Parameters:
    ///   - functionDeclaration: A function from the protocol to which the mock
    ///     must conform.
    ///   - accessLevel: The access level to apply to the function conformance
    ///     declaration.
    /// - Returns: A function conformance declaration to apply to the mock.
    private static func mockFunctionConformanceDeclaration(
        for functionDeclaration: FunctionDeclSyntax,
        with accessLevel: AccessLevelSyntax
    ) throws -> FunctionDeclSyntax {
        let name = functionDeclaration.name.trimmed

        var invocation = ""

        if let invocationKeywordTokens =
            functionDeclaration.invocationKeywordTokens
        {
            let joinedInvocationKeywordTokens =
                invocationKeywordTokens
                    .map(\.text)
                    .joined(separator: " ")

            invocation += "\(joinedInvocationKeywordTokens) "
        }

        if let arguments = functionDeclaration.parameterVariableNames {
            let joinedArguments =
                arguments
                    .map(\.text)
                    .joined(separator: ", ")

            invocation += "self._\(name).invoke((\(joinedArguments)))"
        } else {
            invocation += "self._\(name).invoke()"
        }

        return try functionDeclaration
            .trimmed
            .withAccessLevel(accessLevel)
            .withBody {
                CodeBlockItemSyntax(stringLiteral: invocation)
            }
    }
}

// MARK: - Plugin

@main
struct MockablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MockableMacro.self
    ]
}
