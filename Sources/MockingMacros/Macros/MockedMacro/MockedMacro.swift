//
//  MockedMacro.swift
//
//  Copyright © 2025 Fetch.
//

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros
import SwiftSyntaxSugar

public struct MockedMacro: PeerMacro {

    // MARK: Expansion

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let protocolDeclaration = declaration.as(ProtocolDeclSyntax.self) else {
            throw MacroError.canOnlyBeAppliedToProtocols
        }

        let macroArguments = MacroArguments(node: node)
        let mockDeclaration = DeclSyntax(
            ClassDeclSyntax(
                attributes: AttributeListSyntax {
                    AttributeSyntax(
                        atSign: .atSignToken(),
                        attributeName: IdentifierTypeSyntax(name: "MockedMembers"),
                        trailingTrivia: .newline
                    )
                },
                modifiers: self.mockModifiers(from: protocolDeclaration),
                classKeyword: .keyword(
                    protocolDeclaration.isActorConstrained ? .actor : .class
                ),
                name: self.mockName(from: protocolDeclaration),
                genericParameterClause: self.mockGenericParameterClause(
                    from: protocolDeclaration
                ),
                inheritanceClause: self.mockInheritanceClause(
                    from: protocolDeclaration,
                    sendableConformance: macroArguments.sendableConformance
                ),
                genericWhereClause: self.mockGenericWhereClause(
                    from: protocolDeclaration
                ),
                memberBlock: try self.mockMemberBlock(from: protocolDeclaration)
            )
        )

        guard let compilationCondition = macroArguments.compilationCondition.rawValue else {
            return [mockDeclaration]
        }

        let ifConfigDeclaration = IfConfigDeclSyntax(
            clauses: IfConfigClauseListSyntax {
                IfConfigClauseSyntax(
                    poundKeyword: .poundIfToken(),
                    condition: DeclReferenceExprSyntax(
                        baseName: .identifier(compilationCondition)
                    ),
                    elements: .statements(
                        CodeBlockItemListSyntax {
                            CodeBlockItemSyntax(item: .decl(mockDeclaration))
                        }
                    )
                )
            }
        )

        return [DeclSyntax(ifConfigDeclaration)]
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
        let memberBlock = protocolDeclaration.memberBlock
        let associatedTypeDeclarations = memberBlock.memberDeclarations(
            ofType: AssociatedTypeDeclSyntax.self
        )

        guard !associatedTypeDeclarations.isEmpty else {
            return nil
        }

        return GenericParameterClauseSyntax {
            for associatedTypeDeclaration in associatedTypeDeclarations {
                let genericParameterName = associatedTypeDeclaration.name.trimmed
                let genericInheritedType = associatedTypeDeclaration.inheritanceClause?
                    .inheritedTypes(ofType: IdentifierTypeSyntax.self)
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
    /// - Parameters:
    ///   - protocolDeclaration: The protocol to which the mock must
    ///     conform.
    ///   - sendableConformance: The `Sendable` conformance the mock should have.
    ///     If `.unchecked`, the clause will include `@unchecked Sendable`.
    ///
    /// - Returns: The inheritance clause to apply to the mock declaration.
    private static func mockInheritanceClause(
        from protocolDeclaration: ProtocolDeclSyntax,
        sendableConformance: MockSendableConformance
    ) -> InheritanceClauseSyntax {
        InheritanceClauseSyntax {
            InheritedTypeListSyntax {
                if case .unchecked = sendableConformance {
                    .uncheckedSendable
                }
                InheritedTypeSyntax(type: protocolDeclaration.type)
            }
        }
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
    /// properties and methods of the provided protocol.
    ///
    /// - Parameter protocolDeclaration: The protocol to which the mock must
    ///   conform.
    /// - Returns: The member block to apply to the mock.
    private static func mockMemberBlock(
        from protocolDeclaration: ProtocolDeclSyntax
    ) throws -> MemberBlockSyntax {
        let accessLevel = protocolDeclaration.minimumConformingAccessLevel
        let memberBlock = protocolDeclaration.memberBlock
        let initializerDeclarations = memberBlock.memberDeclarations(
            ofType: InitializerDeclSyntax.self
        )
        let propertyDeclarations = memberBlock.memberDeclarations(
            ofType: VariableDeclSyntax.self
        )
        let methodDeclarations = memberBlock.memberDeclarations(
            ofType: FunctionDeclSyntax.self
        )

        return try MemberBlockSyntax {
            for initializerDeclaration in initializerDeclarations {
                try self.mockInitializerConformanceDeclaration(
                    with: accessLevel,
                    from: initializerDeclaration
                )
            }

            for propertyDeclaration in propertyDeclarations {
                for binding in propertyDeclaration.bindings {
                    try self.mockPropertyConformanceDeclaration(
                        with: accessLevel,
                        for: binding,
                        from: propertyDeclaration
                    )
                }
            }

            for methodDeclaration in methodDeclarations {
                try self.mockMethodConformanceDeclaration(
                    with: accessLevel,
                    for: methodDeclaration,
                    in: protocolDeclaration
                )
            }
        }
    }

    // MARK: Initializers

    /// Returns an initializer conformance declaration to apply to the mock,
    /// generated from the provided protocol initializer and marked with the
    /// provided access level.
    ///
    /// - Parameters:
    ///   - accessLevel: The access level to apply to the initializer
    ///     conformance declaration.
    ///   - initializerDeclaration: The protocol's initializer declaration.
    /// - Returns: An initializer conformance declaration to apply to the mock.
    private static func mockInitializerConformanceDeclaration(
        with accessLevel: AccessLevelSyntax,
        from initializerDeclaration: InitializerDeclSyntax
    ) throws -> InitializerDeclSyntax {
        try initializerDeclaration
            .trimmed
            .withAccessLevel(accessLevel)
            .with(\.body) {}
    }

    // MARK: Properties

    /// Returns a property conformance declaration to apply to the mock,
    /// generated from the provided protocol `propertyBinding` and marked with
    /// the provided `accessLevel`.
    ///
    /// - Parameters:
    ///   - accessLevel: The access level to apply to the property conformance
    ///     declaration.
    ///   - propertyBinding: A property binding from the protocol to which the
    ///     mock must conform.
    ///   - propertyDeclaration: The property declaration that contains the
    ///     `propertyBinding`.
    /// - Returns: A property conformance declaration to apply to the mock.
    private static func mockPropertyConformanceDeclaration(
        with accessLevel: AccessLevelSyntax,
        for propertyBinding: PatternBindingSyntax,
        from propertyDeclaration: VariableDeclSyntax
    ) throws -> VariableDeclSyntax {
        let modifiers = self.mockConformanceDeclarationModifiers(
            from: propertyDeclaration.modifiers,
            with: accessLevel
        )

        var attributeArgument: LabeledExprSyntax?

        switch (
            propertyBinding.accessorBlock?.getAccessorDeclaration,
            propertyBinding.accessorBlock?.setAccessorDeclaration
        ) {
        case let (.some(getAccessorDeclaration), .none):
            let readOnlyArguments = LabeledExprListSyntax {
                if getAccessorDeclaration.isAsync {
                    LabeledExprSyntax(
                        expression: MemberAccessExprSyntax(
                            period: .periodToken(),
                            name: "async"
                        )
                    )
                }

                if getAccessorDeclaration.isThrowing {
                    LabeledExprSyntax(
                        expression: MemberAccessExprSyntax(
                            period: .periodToken(),
                            name: "throws"
                        )
                    )
                }
            }

            let readOnlyMemberAccessExpression = MemberAccessExprSyntax(
                period: .periodToken(),
                name: "readOnly"
            )

            attributeArgument = if readOnlyArguments.isEmpty {
                LabeledExprSyntax(
                    expression: readOnlyMemberAccessExpression
                )
            } else {
                LabeledExprSyntax(
                    expression: FunctionCallExprSyntax(
                        calledExpression: readOnlyMemberAccessExpression,
                        leftParen: .leftParenToken(),
                        arguments: readOnlyArguments,
                        rightParen: .rightParenToken()
                    )
                )
            }
        case (.some, .some):
            attributeArgument = LabeledExprSyntax(
                expression: MemberAccessExprSyntax(
                    period: .periodToken(),
                    name: "readWrite"
                )
            )
        case (_, _):
            attributeArgument = nil
        }

        let attributes: AttributeListSyntax = if let attributeArgument {
            [
                .attribute(
                    AttributeSyntax(
                        atSign: .atSignToken(),
                        attributeName: IdentifierTypeSyntax(
                            name: "MockableProperty"
                        ),
                        leftParen: .leftParenToken(),
                        arguments: .argumentList(
                            LabeledExprListSyntax {
                                attributeArgument
                            }
                        ),
                        rightParen: .rightParenToken(),
                        trailingTrivia: .newline
                    )
                ),
            ]
        } else {
            []
        }

        return VariableDeclSyntax(
            attributes: attributes,
            modifiers: modifiers,
            bindingSpecifier: .keyword(.var),
            bindingsBuilder: {
                PatternBindingSyntax(
                    pattern: propertyBinding.pattern,
                    typeAnnotation: propertyBinding.typeAnnotation
                )
            }
        )
    }

    // MARK: Methods

    /// Returns a method conformance declaration to apply to the mock, generated
    /// from the provided protocol method and marked with the provided access
    /// level.
    ///
    /// - Parameters:
    ///   - accessLevel: The access level to apply to the method conformance
    ///     declaration.
    ///   - methodDeclaration: A method from the protocol to which the mock must
    ///     conform.
    /// - Returns: A method conformance declaration to apply to the mock.
    private static func mockMethodConformanceDeclaration(
        with accessLevel: AccessLevelSyntax,
        for methodDeclaration: FunctionDeclSyntax,
        in protocolDeclaration: ProtocolDeclSyntax
    ) throws -> FunctionDeclSyntax {
        try methodDeclaration
            .trimmed
            .withAccessLevel(accessLevel)
            .with(\.modifiers) { modifiers in
                let shouldIncludeModifier: (DeclModifierSyntax) -> Bool = { modifier in
                    let excludedTokenKinds: [TokenKind] = [
                        .keyword(.mutating),
                        .keyword(.nonmutating),
                    ]

                    return !excludedTokenKinds.contains(modifier.name.tokenKind)
                }

                for modifier in modifiers where shouldIncludeModifier(modifier) {
                    modifier
                }
            }
    }

    // MARK: Modifiers

    /// Returns modifiers to apply to override declarations, generated using the
    /// provided `protocolDeclaration`, `accessLevel`, and protocol requirement
    /// `modifiers`.
    ///
    /// - Parameters:
    ///   - modifiers: The modifiers taken from the protocol requirement.
    ///   - accessLevel: The access level to apply to the override declaration.
    ///   - protocolDeclaration: The protocol being mocked.
    /// - Returns: Modifiers to apply to override declarations.
    private static func mockOverrideDeclarationModifiers(
        from modifiers: DeclModifierListSyntax,
        with accessLevel: AccessLevelSyntax,
        in protocolDeclaration: ProtocolDeclSyntax
    ) -> DeclModifierListSyntax {
        let shouldIncludeModifier: (DeclModifierSyntax) -> Bool = { modifier in
            let isModifierNonIsolated = modifier.name.tokenKind != .keyword(.nonisolated)
            let isProtocolActorConstrained = protocolDeclaration.isActorConstrained

            return !modifier.isAccessLevel
                && (!isProtocolActorConstrained || !isModifierNonIsolated)
        }

        return DeclModifierListSyntax {
            if accessLevel != .internal {
                accessLevel.modifier
            }

            for modifier in modifiers where shouldIncludeModifier(modifier) {
                modifier.trimmed
            }

            if protocolDeclaration.isActorConstrained {
                DeclModifierSyntax(name: .keyword(.nonisolated))
            }
        }
    }

    /// Returns modifiers to apply to a conformance declaration, generated using
    /// the provided `accessLevel` and protocol requirement `modifiers`.
    ///
    /// - Parameters:
    ///   - modifiers: The modifiers taken from the protocol requirement.
    ///   - accessLevel: The access level to apply to the conformance
    ///     declaration.
    /// - Returns: Modifiers to apply to a conformance declaration.
    private static func mockConformanceDeclarationModifiers(
        from modifiers: DeclModifierListSyntax,
        with accessLevel: AccessLevelSyntax
    ) -> DeclModifierListSyntax {
        DeclModifierListSyntax {
            if accessLevel != .internal {
                accessLevel.modifier
            }

            for modifier in modifiers where !modifier.isAccessLevel {
                modifier.trimmed
            }
        }
    }
}
