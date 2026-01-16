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

        if let conflictingConditionalClauses = self.conflictingConditionalClauses(
            from: protocolDeclaration.memberBlock.members
        ) {
            return try self.expansionWithConditionalConformance(
                protocolDeclaration: protocolDeclaration,
                macroArguments: macroArguments,
                clauses: conflictingConditionalClauses
            )
        }

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
    /// The clause supports associated types with comma-separated constraints,
    /// composition (`&`), or a combination of both. Associated types inside
    /// `#if` blocks are also extracted.
    ///
    /// ```swift
    /// @Mocked
    /// protocol Dependency {
    ///     associatedtype Item: Equatable & Identifiable, Sendable
    /// }
    ///
    /// final class DependencyMock<Item: Sendable & Equatable & Identifiable>: Dependency {}
    /// ```
    ///
    /// - Parameters:
    ///   - protocolDeclaration: The protocol to which the mock must conform.
    ///   - excludingConstraintsFor: Names of associated types whose constraints
    ///     should be excluded (used for conditional conformance).
    /// - Returns: The generic parameter clause to apply to the mock declaration.
    private static func mockGenericParameterClause(
        from protocolDeclaration: ProtocolDeclSyntax,
        excludingConstraintsFor excludedNames: Set<String> = []
    ) -> GenericParameterClauseSyntax? {
        let memberBlock = protocolDeclaration.memberBlock
        let associatedTypeDeclarations = self.associatedTypeDeclarations(
            from: memberBlock.members
        )

        guard !associatedTypeDeclarations.isEmpty else {
            return nil
        }

        // Deduplicate by name (same associated type may appear in multiple #if branches)
        var seenNames: Set<String> = []
        let uniqueAssociatedTypes = associatedTypeDeclarations.filter { decl in
            let name = decl.name.text
            if seenNames.contains(name) {
                return false
            }
            seenNames.insert(name)
            return true
        }

        return GenericParameterClauseSyntax {
            for associatedTypeDeclaration in uniqueAssociatedTypes {
                let genericParameterName = associatedTypeDeclaration.name.trimmed
                let shouldExcludeConstraints = excludedNames
                    .contains(associatedTypeDeclaration.name.text)

                if !shouldExcludeConstraints,
                   let inheritanceClause = associatedTypeDeclaration.inheritanceClause
                {
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

                    GenericParameterSyntax(
                        name: genericParameterName,
                        colon: .colonToken(),
                        inheritedType: CompositionTypeSyntax(elements: inheritedTypeElements)
                    )
                } else {
                    GenericParameterSyntax(name: genericParameterName)
                }
            }
        }
    }

    /// Returns the associated type declarations from the provided `members`,
    /// including those inside `#if` declarations.
    ///
    /// - Parameter members: The members to search.
    /// - Returns: The associated type declarations from the provided `members`.
    private static func associatedTypeDeclarations(
        from members: MemberBlockItemListSyntax
    ) -> [AssociatedTypeDeclSyntax] {
        members.flatMap { member -> [AssociatedTypeDeclSyntax] in
            if let associatedTypeDeclaration = member.decl.as(AssociatedTypeDeclSyntax.self) {
                return [associatedTypeDeclaration]
            } else if let ifConfigDeclaration = member.decl.as(IfConfigDeclSyntax.self) {
                return self.associatedTypeDeclarations(from: ifConfigDeclaration)
            } else {
                return []
            }
        }
    }

    /// Returns the associated type declarations from the provided
    /// `ifConfigDeclaration`.
    ///
    /// This method recursively searches nested `#if` declarations.
    ///
    /// - Parameter ifConfigDeclaration: The `#if` declaration to search.
    /// - Returns: The associated type declarations from the provided
    ///   `ifConfigDeclaration`.
    private static func associatedTypeDeclarations(
        from ifConfigDeclaration: IfConfigDeclSyntax
    ) -> [AssociatedTypeDeclSyntax] {
        ifConfigDeclaration.clauses.flatMap { clause -> [AssociatedTypeDeclSyntax] in
            guard case let .decls(members) = clause.elements else {
                return []
            }

            return self.associatedTypeDeclarations(from: members)
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
    ///     If `.unchecked`, the inheritance clause will include `@unchecked Sendable`.
    /// - Returns: The inheritance clause to apply to the mock declaration.
    private static func mockInheritanceClause(
        from protocolDeclaration: ProtocolDeclSyntax,
        sendableConformance: MockSendableConformance
    ) -> InheritanceClauseSyntax {
        InheritanceClauseSyntax {
            InheritedTypeListSyntax {
                if case .unchecked = sendableConformance {
                    .uncheckedSendable
                        .with(\.trailingComma, .commaToken())
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
        guard !protocolDeclaration.genericWhereClauses.isEmpty else {
            return nil
        }

        return GenericWhereClauseSyntax {
            protocolDeclaration.genericWhereClauses
                .flatMap(\.requirements)
                .map(\.trimmed)
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

// MARK: - Conditional Associated Type Conformance

extension MockedMacro {

    /// A tuple representing one clause of an `#if` block containing associated
    /// types with their conditional compilation condition.
    ///
    /// - `condition`: The conditional compilation expression (e.g., `DEBUG`),
    ///   or `nil` for `#else` clauses.
    /// - `associatedTypes`: The associated type declarations within this clause.
    private typealias ConditionalClause = (
        condition: ExprSyntax?,
        associatedTypes: [AssociatedTypeDeclSyntax]
    )

    /// Returns conditional clauses containing associated types with conflicting
    /// constraints across different `#if` branches.
    ///
    /// This method detects when the same associated type has different constraints
    /// in different conditional compilation branches, requiring conditional conformance.
    ///
    /// - Parameter members: The protocol members to search for conflicting
    ///   conditional associated types.
    /// - Returns: An array of conditional clauses if conflicts are found, or
    ///   `nil` if there are no conflicts.
    private static func conflictingConditionalClauses(
        from members: MemberBlockItemListSyntax
    ) -> [ConditionalClause]? {
        members
            .compactMap { member in member.decl.as(IfConfigDeclSyntax.self) }
            .compactMap { ifConfigDeclaration -> [ConditionalClause]? in
                let clauses = ifConfigDeclaration.clauses
                    .compactMap { clause -> ConditionalClause? in
                        guard case let .decls(declarations) = clause.elements else {
                            return nil
                        }

                        let associatedTypes = declarations.compactMap { declaration in
                            declaration.decl.as(AssociatedTypeDeclSyntax.self)
                        }

                        guard !associatedTypes.isEmpty else {
                            return nil
                        }

                        return (clause.condition, associatedTypes)
                    }

                guard !clauses.isEmpty else {
                    return nil
                }

                let constraintSetsByTypeName = Dictionary(
                    grouping: clauses.flatMap(\.associatedTypes),
                    by: \.name.text
                ).mapValues { types in
                    Set(types.map { type in
                        type.inheritanceClause?.description
                            .trimmingCharacters(in: .whitespaces) ?? ""
                    })
                }

                guard constraintSetsByTypeName.values.contains(where: { $0.count > 1 }) else {
                    return nil
                }

                return clauses
            }
            .first
    }

    /// Returns the macro expansion with conditional conformance extensions
    /// for protocols with conflicting associated type constraints in `#if` blocks.
    ///
    /// This method generates a mock class without associated type constraints,
    /// along with conditional extensions that conform to the protocol under
    /// specific compilation conditions with the appropriate constraints applied.
    ///
    /// - Parameters:
    ///   - protocolDeclaration: The protocol to which the mock must conform.
    ///   - macroArguments: The macro arguments provided to the `@Mocked` attribute.
    ///   - clauses: The conditional clauses containing conflicting associated
    ///     type constraints.
    /// - Returns: The declarations to generate, including the mock class and
    ///   conditional conformance extensions.
    private static func expansionWithConditionalConformance(
        protocolDeclaration: ProtocolDeclSyntax,
        macroArguments: MacroArguments,
        clauses: [ConditionalClause]
    ) throws -> [DeclSyntax] {
        let mockName = self.mockName(from: protocolDeclaration)
        let associatedTypeNamesToExclude = Set(clauses.flatMap { clause in
            clause.associatedTypes.map(\.name.text)
        })

        let mockDeclaration = ClassDeclSyntax(
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
            genericParameterClause: self.mockGenericParameterClause(
                from: protocolDeclaration,
                excludingConstraintsFor: associatedTypeNamesToExclude
            ),
            inheritanceClause: macroArguments.sendableConformance == .unchecked
                ? InheritanceClauseSyntax { InheritedTypeSyntax.uncheckedSendable }
                : nil,
            genericWhereClause: self.mockGenericWhereClause(from: protocolDeclaration),
            memberBlock: try self.mockMemberBlock(from: protocolDeclaration)
        )

        let ifConfigDeclaration = IfConfigDeclSyntax(
            clauses: IfConfigClauseListSyntax(
                clauses.enumerated().map { index, clause in
                    IfConfigClauseSyntax(
                        poundKeyword: index == 0
                            ? .poundIfToken()
                            : clause.condition != nil ? .poundElseifToken() : .poundElseToken(),
                        condition: clause.condition,
                        elements: .decls(MemberBlockItemListSyntax {
                            MemberBlockItemSyntax(decl: ExtensionDeclSyntax(
                                extendedType: IdentifierTypeSyntax(name: mockName),
                                inheritanceClause: InheritanceClauseSyntax {
                                    InheritedTypeSyntax(type: protocolDeclaration.type)
                                },
                                genericWhereClause: self.whereClause(from: clause.associatedTypes),
                                memberBlock: MemberBlockSyntax(members: [])
                            ))
                        })
                    )
                }
            )
        )

        let declarations: [DeclSyntax] = [
            DeclSyntax(mockDeclaration),
            DeclSyntax(ifConfigDeclaration),
        ]

        guard let condition = macroArguments.compilationCondition.rawValue else {
            return declarations
        }

        return [DeclSyntax(IfConfigDeclSyntax(clauses: IfConfigClauseListSyntax {
            IfConfigClauseSyntax(
                poundKeyword: .poundIfToken(),
                condition: DeclReferenceExprSyntax(baseName: .identifier(condition)),
                elements: .statements(CodeBlockItemListSyntax(
                    declarations.map { declaration in
                        CodeBlockItemSyntax(item: .decl(declaration))
                    }
                ))
            )
        }))]
    }

    /// Builds a generic `where` clause from associated type constraints.
    ///
    /// This method extracts all constraints from the provided associated types
    /// and combines them into a single `where` clause. It handles both simple
    /// constraints (e.g., `Item: Equatable`) and composition constraints
    /// (e.g., `Item: Equatable & Sendable`).
    ///
    /// For example, given these associated types:
    ///
    /// ```swift
    /// associatedtype Item: Equatable
    /// associatedtype Value: Codable & Sendable
    /// ```
    ///
    /// This method generates:
    ///
    /// ```swift
    /// where Item: Equatable, Value: Codable, Value: Sendable
    /// ```
    ///
    /// This is used when creating conditional conformance extensions for mocks
    /// where different `#if` branches define conflicting constraints for the
    /// same associated type.
    ///
    /// - Parameter associatedTypes: The associated type declarations from which
    ///   to extract constraints.
    /// - Returns: A generic `where` clause containing all the constraints, or
    ///   `nil` if no constraints are found.
    private static func whereClause(
        from associatedTypes: [AssociatedTypeDeclSyntax]
    ) -> GenericWhereClauseSyntax? {
        let allConstraints = associatedTypes.flatMap { associatedType -> [(
            name: TokenSyntax,
            type: TypeSyntax
        )] in
            guard let inheritanceClause = associatedType.inheritanceClause else {
                return []
            }

            let identifierTypes = inheritanceClause
                .inheritedTypes(ofType: IdentifierTypeSyntax.self)
                .map(TypeSyntax.init)

            let compositionTypes = inheritanceClause
                .inheritedTypes(ofType: CompositionTypeSyntax.self)
                .flatMap(\.elements)
                .map { compositionType in
                    TypeSyntax(compositionType.type)
                }

            return (identifierTypes + compositionTypes).map { type in (
                associatedType.name.trimmed,
                type
            ) }
        }

        guard !allConstraints.isEmpty else {
            return nil
        }

        return GenericWhereClauseSyntax {
            allConstraints.map { constraint in
                GenericRequirementSyntax(requirement: .conformanceRequirement(
                    ConformanceRequirementSyntax(
                        leftType: IdentifierTypeSyntax(name: constraint.name),
                        colon: .colonToken(),
                        rightType: constraint.type.trimmed
                    )
                ))
            }
        }
    }
}
