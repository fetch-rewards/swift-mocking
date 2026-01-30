//
//  MockedMacro.swift
//
//  Copyright © 2026 Fetch.
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
        let mockName = self.mockName(from: protocolDeclaration)
        let mockGenericSpecialization = self.mockGenericSpecialization(
            mockName: mockName,
            protocolDeclaration: protocolDeclaration
        )
        let mockDeclaration = try self.mockDeclaration(
            from: protocolDeclaration,
            macroArguments: macroArguments,
            mockName: mockName,
            mockGenericParameterClause: mockGenericSpecialization.mockGenericParameterClause,
            mockGenericWhereClause: mockGenericSpecialization.mockGenericWhereClause,
            shouldMockConformToProtocol: mockGenericSpecialization.mockPeerIfConfigDeclarations.isEmpty
        )

        let declarations = [DeclSyntax(mockDeclaration)]
            + mockGenericSpecialization.mockPeerIfConfigDeclarations.map(DeclSyntax.init)

        guard let compilationCondition = macroArguments.compilationCondition.rawValue else {
            return declarations
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
                            for declaration in declarations {
                                CodeBlockItemSyntax(item: .decl(declaration))
                            }
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

    // MARK: Declaration

    /// Returns a mock declaration, generated from the provided protocol.
    ///
    /// - Parameters:
    ///   - protocolDeclaration: The protocol to which the mock must conform.
    ///   - macroArguments: The arguments passed to the macro.
    ///   - mockName: The name of the mock.
    ///   - mockGenericParameterClause: The mock's generic parameter clause.
    ///   - mockGenericWhereClause: The mock's generic where clause.
    ///   - shouldMockConformToProtocol: A Boolean value indicating whether the
    ///     mock should conform to the protocol. If the mock has extensions that
    ///     handle conditional conformance, this value should be `false`.
    /// - Returns: A mock declaration.
    private static func mockDeclaration(
        from protocolDeclaration: ProtocolDeclSyntax,
        macroArguments: MacroArguments,
        mockName: TokenSyntax,
        mockGenericParameterClause: GenericParameterClauseSyntax?,
        mockGenericWhereClause: GenericWhereClauseSyntax?,
        shouldMockConformToProtocol: Bool
    ) throws -> ClassDeclSyntax {
        ClassDeclSyntax(
            attributes: AttributeListSyntax {
                AttributeSyntax(
                    atSign: .atSignToken(),
                    attributeName: IdentifierTypeSyntax(name: "MockedMembers"),
                    trailingTrivia: .newline
                )
            },
            modifiers: self.mockModifiers(from: protocolDeclaration),
            classKeyword: .keyword(protocolDeclaration.isActorConstrained ? .actor : .class),
            name: mockName,
            genericParameterClause: mockGenericParameterClause,
            inheritanceClause: self.mockInheritanceClause(
                from: protocolDeclaration,
                shouldConformToProtocol: shouldMockConformToProtocol,
                sendableConformance: macroArguments.sendableConformance
            ),
            genericWhereClause: mockGenericWhereClause,
            memberBlock: try self.mockMemberBlock(from: protocolDeclaration)
        )
    }

    // MARK: Name

    /// Returns the name of the mock, generated from the provided protocol.
    ///
    /// - Parameter protocolDeclaration: The protocol being mocked.
    /// - Returns: The name of the mock.
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

    // MARK: Generic Specialization

    /// Returns a tuple containing a generic parameter clause, a generic where
    /// clause, and zero or more `IfConfigDeclSyntax` objects containing
    /// extensions that conditionally conform the mock to the provided
    /// `protocolDeclaration`.
    ///
    /// - Parameters:
    ///   - mockName: The name of the mock.
    ///   - protocolDeclaration: The protocol to which the mock must conform.
    /// - Returns: A tuple containing a generic parameter clause, a generic
    ///   where clause, and zero or more `IfConfigDeclSyntax` objects containing
    ///   extensions that conditionally conform the mock to the provided
    ///   `protocolDeclaration`.
    private static func mockGenericSpecialization(
        mockName: TokenSyntax,
        protocolDeclaration: ProtocolDeclSyntax
    ) -> (
        mockGenericParameterClause: GenericParameterClauseSyntax?,
        mockGenericWhereClause: GenericWhereClauseSyntax?,
        mockPeerIfConfigDeclarations: [IfConfigDeclSyntax]
    ) {
        let protocolGenericRequirements = protocolDeclaration.genericWhereClause?.requirements

        var mockGenericParameters: [GenericParameterSyntax] = []
        var mockGenericWhereClauseRequirements = protocolGenericRequirements?.map(
            \.requirement
        ) ?? []
        var mockPeerIfConfigDeclarations: [IfConfigDeclSyntax] = []

        for member in protocolDeclaration.memberBlock.members {
            if let associatedTypeDeclaration = member.decl.as(AssociatedTypeDeclSyntax.self) {
                let mockGenericParameter = self.mockGenericParameter(
                    from: associatedTypeDeclaration
                )

                self.appendGenericParameter(mockGenericParameter, to: &mockGenericParameters)

                if let associatedTypeGenericWhereClause = associatedTypeDeclaration.genericWhereClause {
                    mockGenericWhereClauseRequirements.append(
                        contentsOf: associatedTypeGenericWhereClause.requirements.map(
                            \.requirement
                        )
                    )
                }
            } else if
                let ifConfigDeclaration = member.decl.as(IfConfigDeclSyntax.self),
                let mockPeerIfConfigDeclaration = self.mockPeerIfConfigDeclaration(
                    from: ifConfigDeclaration,
                    in: protocolDeclaration,
                    mockName: mockName,
                    mockGenericParameters: &mockGenericParameters
                )
            {
                mockPeerIfConfigDeclarations.append(mockPeerIfConfigDeclaration)
            }
        }

        let mockGenericParameterClause = self.genericParameterClause(
            parameters: mockGenericParameters
        )
        let mockGenericWhereClause = self.genericWhereClause(
            requirements: mockGenericWhereClauseRequirements
        )

        return (
            mockGenericParameterClause,
            mockGenericWhereClause,
            mockPeerIfConfigDeclarations
        )
    }

    /// Returns an `IfConfigDeclSyntax` containing extensions that conditionally
    /// conform the mock to the provided `protocolDeclaration`, or `nil` if the
    /// mock does not need to conditionally conform to the provided
    /// `protocolDeclaration`.
    ///
    /// This method maintains the structure and conditions of the provided
    /// `ifConfigDeclaration`.
    ///
    /// - Parameters:
    ///   - protocolIfConfigDeclaration: An `IfConfigDeclSyntax` from the
    ///     provided `protocolDeclaration`.
    ///   - protocolDeclaration: The protocol to which the mock must conform.
    ///   - mockName: The name of the mock.
    ///   - mockGenericParameters: The mock's generic parameters.
    /// - Returns: An `IfConfigDeclSyntax` containing extensions that
    ///   conditionally conform the mock to the provided `protocolDeclaration`,
    ///   or `nil` if the mock does not need to conditionally conform to the
    ///   provided `protocolDeclaration`.
    private static func mockPeerIfConfigDeclaration(
        from protocolIfConfigDeclaration: IfConfigDeclSyntax,
        in protocolDeclaration: ProtocolDeclSyntax,
        mockName: TokenSyntax,
        mockGenericParameters: inout [GenericParameterSyntax]
    ) -> IfConfigDeclSyntax? {
        var mockPeerIfConfigClauses: [IfConfigClauseSyntax] = []
        var mockNeedsConditionalConformance = false

        for protocolIfConfigClause in protocolIfConfigDeclaration.clauses {
            var mockExtensionGenericWhereClauseRequirements: [
                GenericRequirementSyntax.Requirement
            ] = []

            if case let .decls(members) = protocolIfConfigClause.elements {
                for member in members {
                    guard
                        let associatedTypeDeclaration = member.decl.as(
                            AssociatedTypeDeclSyntax.self
                        )
                    else {
                        continue
                    }

                    let mockGenericParameter = self.mockGenericParameter(
                        from: associatedTypeDeclaration
                    )

                    self.appendGenericParameter(
                        GenericParameterSyntax(name: mockGenericParameter.name),
                        to: &mockGenericParameters
                    )

                    if let mockGenericParameterInheritedType = mockGenericParameter.inheritedType {
                        mockExtensionGenericWhereClauseRequirements.append(
                            .conformanceRequirement(
                                ConformanceRequirementSyntax(
                                    leftType: IdentifierTypeSyntax(
                                        name: mockGenericParameter.name
                                    ),
                                    rightType: mockGenericParameterInheritedType
                                )
                            )
                        )
                    }

                    if let associatedTypeGenericWhereClause = associatedTypeDeclaration.genericWhereClause {
                        mockExtensionGenericWhereClauseRequirements.append(
                            contentsOf: associatedTypeGenericWhereClause.requirements.map(
                                \.requirement
                            )
                        )
                    }
                }
            }

            if !mockExtensionGenericWhereClauseRequirements.isEmpty {
                mockNeedsConditionalConformance = true
            }

            let mockExtensionGenericWhereClause = self.genericWhereClause(
                requirements: mockExtensionGenericWhereClauseRequirements
            )
            let mockExtensionDeclaration = ExtensionDeclSyntax(
                extendedType: IdentifierTypeSyntax(name: mockName),
                inheritanceClause: InheritanceClauseSyntax {
                    InheritedTypeSyntax(type: protocolDeclaration.type)
                },
                genericWhereClause: mockExtensionGenericWhereClause
            ) {}
            let mockPeerIfConfigClause = IfConfigClauseSyntax(
                poundKeyword: protocolIfConfigClause.poundKeyword.trimmed,
                condition: protocolIfConfigClause.condition?.trimmed,
                elements: .decls(
                    MemberBlockItemListSyntax {
                        MemberBlockItemSyntax(decl: mockExtensionDeclaration)
                    }
                )
            )

            mockPeerIfConfigClauses.append(mockPeerIfConfigClause)
        }

        guard mockNeedsConditionalConformance else {
            return nil
        }

        return IfConfigDeclSyntax(
            clauses: IfConfigClauseListSyntax(mockPeerIfConfigClauses)
        )
    }

    // MARK: Generic Parameter Clause

    /// Returns a generic parameter to apply to the mock, generated from the
    /// provided `associatedTypeDeclaration`.
    ///
    /// - Parameter associatedTypeDeclaration: An associated type declaration
    ///   from the protocol to which the mock must conform.
    /// - Returns: A generic parameter to apply to the mock.
    private static func mockGenericParameter(
        from associatedTypeDeclaration: AssociatedTypeDeclSyntax
    ) -> GenericParameterSyntax {
        let genericParameterName = associatedTypeDeclaration.name.trimmed

        guard let inheritanceClause = associatedTypeDeclaration.inheritanceClause else {
            return GenericParameterSyntax(name: genericParameterName)
        }

        let commaSeparatedInheritedTypes = inheritanceClause
            .inheritedTypes(ofType: IdentifierTypeSyntax.self)
            .compactMap { CompositionTypeElementSyntax(type: $0) }

        let composedInheritedTypes = inheritanceClause
            .inheritedTypes(ofType: CompositionTypeSyntax.self)
            .flatMap(\.elements)

        let inheritedTypes = commaSeparatedInheritedTypes + composedInheritedTypes
        let lastIndex = inheritedTypes.count - 1
        let inheritedTypeElements = CompositionTypeElementListSyntax {
            for (index, inheritedType) in inheritedTypes.enumerated() {
                inheritedType
                    .trimmed
                    .with(\.ampersand, index < lastIndex ? .binaryOperator("&") : nil)
            }
        }

        return GenericParameterSyntax(
            name: genericParameterName,
            colon: .colonToken(),
            inheritedType: CompositionTypeSyntax(elements: inheritedTypeElements)
        )
    }

    /// Appends the provided `genericParameter` to the provided
    /// `genericParameters`, unless another generic parameter of the same name
    /// already exists, in which case this method does nothing.
    ///
    /// - Parameters:
    ///   - genericParameter: The generic parameter to append to the provided
    ///     `genericParameters`.
    ///   - genericParameters: The generic parameters to which to append the
    ///     provided `genericParameter`.
    private static func appendGenericParameter(
        _ genericParameter: GenericParameterSyntax,
        to genericParameters: inout [GenericParameterSyntax]
    ) {
        let isDuplicate = genericParameters.contains { existingGenericParameter in
            genericParameter.name.tokenKind == existingGenericParameter.name.tokenKind
        }

        guard !isDuplicate else {
            return
        }

        genericParameters.append(genericParameter)
    }

    /// Returns a generic parameter clause with the provided `parameters`, or
    /// `nil` if `parameters` is empty.
    ///
    /// - Parameter parameters: The generic parameters to include in the generic
    ///   parameter clause.
    /// - Returns: A generic parameter clause with the provided `parameters`, or
    ///   `nil` if `parameters` is empty.
    private static func genericParameterClause(
        parameters: [GenericParameterSyntax]
    ) -> GenericParameterClauseSyntax? {
        guard !parameters.isEmpty else {
            return nil
        }

        return GenericParameterClauseSyntax {
            for (index, parameter) in parameters.enumerated() {
                parameter.with(
                    \.trailingComma,
                    index < parameters.count - 1 ? .commaToken() : nil
                )
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
    ///   - protocolDeclaration: The protocol to which the mock must conform.
    ///   - shouldConformToProtocol: A Boolean value indicating whether the mock
    ///     should conform to the protocol. If the mock has extensions that
    ///     handle conditional conformance, this value should be `false`.
    ///   - sendableConformance: The `Sendable` conformance the mock should have.
    ///     If `.unchecked`, the inheritance clause will include `@unchecked Sendable`.
    /// - Returns: The inheritance clause to apply to the mock declaration.
    private static func mockInheritanceClause(
        from protocolDeclaration: ProtocolDeclSyntax,
        shouldConformToProtocol: Bool,
        sendableConformance: MockSendableConformance
    ) -> InheritanceClauseSyntax? {
        var inheritedTypes: [InheritedTypeSyntax] = []

        if case .unchecked = sendableConformance {
            inheritedTypes.append(.uncheckedSendable)
        }

        if shouldConformToProtocol {
            inheritedTypes.append(InheritedTypeSyntax(type: protocolDeclaration.type))
        }

        guard !inheritedTypes.isEmpty else {
            return nil
        }

        return InheritanceClauseSyntax {
            InheritedTypeListSyntax {
                for (index, inheritedType) in inheritedTypes.enumerated() {
                    inheritedType.with(
                        \.trailingComma,
                        index < inheritedTypes.count - 1 ? .commaToken() : nil
                    )
                }
            }
        }
    }

    // MARK: Generic Where Clause

    /// Returns a generic `where` clause generated from the provided generic
    /// requirements.
    ///
    /// - Parameter requirements: The requirements to apply to the generic
    ///   `where` clause.
    /// - Returns: A generic `where` clause.
    private static func genericWhereClause(
        requirements: [GenericRequirementSyntax.Requirement]
    ) -> GenericWhereClauseSyntax? {
        guard !requirements.isEmpty else {
            return nil
        }

        return GenericWhereClauseSyntax {
            for (index, requirement) in requirements.enumerated() {
                GenericRequirementSyntax(
                    requirement: requirement.trimmed,
                    trailingComma: index < requirements.count - 1 ? .commaToken() : nil
                )
            }
        }
    }

    // MARK: Members

    /// Returns the member block to apply to the mock, generated from the
    /// members from the provided `protocolDeclaration`.
    ///
    /// - Parameter protocolDeclaration: The protocol being mocked.
    /// - Returns: The member block to apply to the mock.
    private static func mockMemberBlock(
        from protocolDeclaration: ProtocolDeclSyntax
    ) throws -> MemberBlockSyntax {
        let accessLevel = protocolDeclaration.minimumConformingAccessLevel
        let members = try self.mockMembers(
            from: protocolDeclaration.memberBlock.members,
            with: accessLevel,
            in: protocolDeclaration
        )

        return MemberBlockSyntax(members: members)
    }

    /// Returns the members to apply to the mock, generated from the provided
    /// `members` from the provided `protocolDeclaration` and marked with the
    /// provided `accessLevel`.
    ///
    /// Associated types are skipped since they become generic parameters for
    /// the mock class rather than member declarations.
    ///
    /// - Parameters:
    ///   - members: The members from the protocol being mocked.
    ///   - accessLevel: The access level to apply to the mock's members.
    ///   - protocolDeclaration: The protocol being mocked.
    /// - Returns: The members to apply to the mock.
    private static func mockMembers(
        from members: MemberBlockItemListSyntax,
        with accessLevel: AccessLevelSyntax,
        in protocolDeclaration: ProtocolDeclSyntax
    ) throws -> MemberBlockItemListSyntax {
        try MemberBlockItemListSyntax {
            for member in members {
                if let initializerDeclaration = member.decl.as(InitializerDeclSyntax.self) {
                    MemberBlockItemSyntax(
                        decl: try self.mockInitializerConformanceDeclaration(
                            with: accessLevel,
                            from: initializerDeclaration
                        )
                    )
                } else if let propertyDeclaration = member.decl.as(VariableDeclSyntax.self) {
                    for binding in propertyDeclaration.bindings {
                        MemberBlockItemSyntax(
                            decl: try self.mockPropertyConformanceDeclaration(
                                with: accessLevel,
                                for: binding,
                                from: propertyDeclaration
                            )
                        )
                    }
                } else if let methodDeclaration = member.decl.as(FunctionDeclSyntax.self) {
                    MemberBlockItemSyntax(
                        decl: try self.mockMethodConformanceDeclaration(
                            with: accessLevel,
                            for: methodDeclaration,
                            in: protocolDeclaration
                        )
                    )
                } else if let ifConfigDeclaration = member.decl.as(IfConfigDeclSyntax.self) {
                    if let mockIfConfigDeclaration = try self.mockIfConfigDeclaration(
                        from: ifConfigDeclaration,
                        with: accessLevel,
                        in: protocolDeclaration
                    ) {
                        MemberBlockItemSyntax(decl: mockIfConfigDeclaration)
                    }
                }
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

    // MARK: If Configs

    /// Returns an `IfConfigDeclSyntax` containing mock member declarations,
    /// generated from the provided `ifConfigDeclaration` from the provided
    /// `protocolDeclaration` and marked with the provided `accessLevel`.
    ///
    /// This method preserves the conditional compilation structure from the
    /// provided `ifConfigDeclaration` in the returned `IfConfigDeclSyntax`.
    ///
    /// - Parameters:
    ///   - ifConfigDeclaration: The `IfConfigDeclSyntax` from the protocol.
    ///   - accessLevel: The access level to apply to the mock declarations.
    ///   - protocolDeclaration: The protocol being mocked.
    /// - Returns: An `IfConfigDeclSyntax` containing mock member declarations,
    ///   or `nil` if none of the clauses contain member declarations (e.g., are
    ///   empty or contain only associated type declarations).
    private static func mockIfConfigDeclaration(
        from ifConfigDeclaration: IfConfigDeclSyntax,
        with accessLevel: AccessLevelSyntax,
        in protocolDeclaration: ProtocolDeclSyntax
    ) throws -> IfConfigDeclSyntax? {
        let clauses = try IfConfigClauseListSyntax(
            ifConfigDeclaration.clauses.map { clause in
                guard case let .decls(members) = clause.elements else {
                    return clause
                }

                let mockMembers = try self.mockMembers(
                    from: members,
                    with: accessLevel,
                    in: protocolDeclaration
                )

                return IfConfigClauseSyntax(
                    poundKeyword: clause.poundKeyword.trimmed,
                    condition: clause.condition?.trimmed,
                    elements: .decls(mockMembers)
                )
            }
        )

        let allClausesEmpty = clauses.allSatisfy { clause in
            guard case let .decls(members) = clause.elements else {
                return true
            }

            return members.isEmpty
        }

        guard !allClausesEmpty else {
            return nil
        }

        return IfConfigDeclSyntax(
            clauses: clauses,
            poundEndif: ifConfigDeclaration.poundEndif.trimmed
        )
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
