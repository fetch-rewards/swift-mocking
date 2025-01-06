//
//  MockedMacro.swift
//  MockedMacros
//
//  Created by Gray Campbell on 11/4/23.
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
    /// properties and methods of the provided protocol.
    ///
    /// - Parameter protocolDeclaration: The protocol to which the mock must
    ///   conform.
    /// - Returns: The member block to apply to the mock.
    private static func mockMemberBlock(
        from protocolDeclaration: ProtocolDeclSyntax
    ) throws -> MemberBlockSyntax {
        let accessLevel = protocolDeclaration.minimumConformingAccessLevel
        let initializerDeclarations = protocolDeclaration.initializerDeclarations
        let propertyDeclarations = protocolDeclaration.variableDeclarations
        let methodDeclarations = protocolDeclaration.functionDeclarations

        var members: [any DeclSyntaxProtocol] = []
        var backingOverrideDeclarations: [VariableDeclSyntax] = []

        let defaultInitializerDeclaration = self.mockDefaultInitializerDeclaration(
            with: accessLevel
        )

        members.append(defaultInitializerDeclaration)

        for initializerDeclaration in initializerDeclarations {
            let initializerConformanceDeclaration = try self.mockInitializerConformanceDeclaration(
                with: accessLevel,
                from: initializerDeclaration
            )

            members.append(initializerConformanceDeclaration)
        }

        for propertyDeclaration in propertyDeclarations {
            for binding in propertyDeclaration.bindings {
                let propertyOverrideDeclarations = self.mockPropertyOverrideDeclarations(
                    with: accessLevel,
                    for: binding,
                    from: propertyDeclaration,
                    in: protocolDeclaration
                )
                let propertyConformanceDeclaration = try self.mockPropertyConformanceDeclaration(
                    with: accessLevel,
                    for: binding,
                    from: propertyDeclaration
                )

                backingOverrideDeclarations.append(
                    propertyOverrideDeclarations.backingProperty
                )
                members.append(propertyOverrideDeclarations.backingProperty)
                members.append(propertyOverrideDeclarations.exposedProperty)
                members.append(propertyConformanceDeclaration)
            }
        }

        for methodDeclaration in methodDeclarations {
            let methodOverrideDeclarations = self.mockMethodOverrideDeclarations(
                with: accessLevel,
                for: methodDeclaration,
                in: protocolDeclaration
            )
            let methodConformanceDeclaration = try self.mockMethodConformanceDeclaration(
                with: accessLevel,
                for: methodDeclaration,
                didTypeEraseOverrideDeclarationsReturnType: methodOverrideDeclarations.didTypeEraseReturnType
            )

            backingOverrideDeclarations.append(
                methodOverrideDeclarations.backingMethod
            )
            members.append(methodOverrideDeclarations.backingMethod)
            members.append(methodOverrideDeclarations.exposedMethod)
            members.append(methodConformanceDeclaration)
        }

        if let resetMockedStaticMembersMethodDeclaration =
            self.resetMockedStaticMembersMethodDeclaration(
                backingOverrideDeclarations: backingOverrideDeclarations,
                protocolDeclaration: protocolDeclaration
            )
        {
            members.append(resetMockedStaticMembersMethodDeclaration)
        }

        return MemberBlockSyntax {
            for member in members {
                member
            }
        }
    }

    // MARK: Initializers

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

    /// Returns property override declarations to apply to the mock, generated
    /// from the provided protocol property binding with the exposed declaration
    /// marked with the provided access level.
    ///
    /// - Parameters:
    ///   - accessLevel: The access level to apply to the exposed property
    ///     override declaration.
    ///   - binding: A property binding from the protocol to which the mock must
    ///     conform.
    ///   - propertyDeclaration: The property declaration that contains the
    ///     binding.
    ///   - protocolDeclaration: The protocol declaration to which the mock must
    ///     conform.
    /// - Returns: Property override declarations to apply to the mock.
    private static func mockPropertyOverrideDeclarations(
        with accessLevel: AccessLevelSyntax,
        for binding: PatternBindingSyntax,
        from propertyDeclaration: VariableDeclSyntax,
        in protocolDeclaration: ProtocolDeclSyntax
    ) -> (
        backingProperty: VariableDeclSyntax,
        exposedProperty: VariableDeclSyntax
    ) {
        let mockName = self.mockName(from: protocolDeclaration)
        let propertyName = binding.pattern.as(IdentifierPatternSyntax.self)!.identifier
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

        backingType += "Property<\(backingGenericType)>"

        return (
            backingProperty: VariableDeclSyntax(
                modifiers: self.mockOverrideDeclarationModifiers(
                    from: propertyDeclaration.modifiers,
                    with: AccessLevelSyntax.private,
                    in: protocolDeclaration
                ),
                .let,
                name: PatternSyntax(stringLiteral: "__\(propertyName)"),
                initializer: InitializerClauseSyntax(
                    value: ExprSyntax(
                        stringLiteral: """
                        \(backingType).makeProperty(
                            exposedPropertyDescription: MockImplementationDescription(
                                type: \(mockName).self,
                                member: "_\(propertyName)"
                            )
                        )
                        """
                    )
                )
            ),
            exposedProperty: VariableDeclSyntax(
                modifiers: self.mockOverrideDeclarationModifiers(
                    from: propertyDeclaration.modifiers,
                    with: accessLevel,
                    in: protocolDeclaration
                ),
                bindingSpecifier: .keyword(.var),
                bindingsBuilder: {
                    PatternBindingSyntax(
                        pattern: PatternSyntax(stringLiteral: "_\(propertyName)"),
                        typeAnnotation: TypeAnnotationSyntax(
                            type: TypeSyntax(stringLiteral: backingType)
                        ),
                        accessorBlock: AccessorBlockSyntax(
                            accessors: .getter(
                                CodeBlockItemListSyntax {
                                    "self.__\(propertyName).property"
                                }
                            )
                        )
                    )
                }
            )
        )
    }

    /// Returns a property conformance declaration to apply to the mock,
    /// generated from the provided protocol property binding and marked with
    /// the provided access level.
    ///
    /// - Parameters:
    ///   - accessLevel: The access level to apply to the property conformance
    ///     declaration.
    ///   - binding: A property binding from the protocol to which the mock must
    ///     conform.
    ///   - propertyDeclaration: The property declaration that contains the
    ///     binding.
    /// - Returns: A property conformance declaration to apply to the mock.
    private static func mockPropertyConformanceDeclaration(
        with accessLevel: AccessLevelSyntax,
        for binding: PatternBindingSyntax,
        from propertyDeclaration: VariableDeclSyntax
    ) throws -> VariableDeclSyntax {
        let propertyName = binding.pattern.as(IdentifierPatternSyntax.self)!.identifier

        func modifier(
            for accessorDeclaration: AccessorDeclSyntax
        ) -> DeclModifierSyntax? {
            let excludedTokenKinds: [TokenKind] = [
                .keyword(.mutating),
                .keyword(.nonmutating),
            ]

            guard
                let modifier = accessorDeclaration.modifier,
                !excludedTokenKinds.contains(modifier.name.tokenKind)
            else {
                return nil
            }

            return modifier
        }

        func getAccessorConformanceDeclaration(
            for getAccessorDeclaration: AccessorDeclSyntax
        ) throws -> AccessorDeclSyntax {
            try getAccessorDeclaration
                .with(\.modifier, modifier(for: getAccessorDeclaration))
                .with(\.body) {
                    let getterInvocationKeywordTokens = getAccessorDeclaration
                        .invocationKeywordTokens

                    if getterInvocationKeywordTokens.isEmpty {
                        "self.__\(propertyName).get()"
                    } else {
                        let joinedGetterInvocationKeywordTokens = getterInvocationKeywordTokens
                            .map(\.text)
                            .joined(separator: " ")

                        "\(raw: joinedGetterInvocationKeywordTokens) self.__\(propertyName).get()"
                    }
                }
        }

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
                    try setAccessorDeclaration
                        .with(\.modifier, modifier(for: setAccessorDeclaration))
                        .with(\.body) {
                            "self.__\(propertyName).set(newValue)"
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
            .getter("self.__\(propertyName).get()")
        }

        return VariableDeclSyntax(
            modifiers: self.mockConformanceDeclarationModifiers(
                from: propertyDeclaration.modifiers,
                with: accessLevel
            ),
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

    // MARK: Methods

    /// Returns method override declarations to apply to the mock, generated
    /// from the provided protocol method with the exposed declaration marked
    /// with the provided access level.
    ///
    /// - Parameters:
    ///   - accessLevel: The access level to apply to the exposed method
    ///     override declaration.
    ///   - methodDeclaration: A method from the protocol to which the mock must
    ///     conform.
    ///   - protocolDeclaration: The protocol being mocked.
    /// - Returns: Method override declarations to apply to the mock.
    private static func mockMethodOverrideDeclarations(
        with accessLevel: AccessLevelSyntax,
        for methodDeclaration: FunctionDeclSyntax,
        in protocolDeclaration: ProtocolDeclSyntax
    ) -> (
        backingMethod: VariableDeclSyntax,
        exposedMethod: VariableDeclSyntax,
        didTypeEraseReturnType: Bool
    ) {
        let mockName = self.mockName(from: protocolDeclaration)
        let methodName = methodDeclaration.name
        let methodGenericParameterClause = methodDeclaration.genericParameterClause
        let methodGenericParameters = methodGenericParameterClause?.parameters
        let methodSignature = methodDeclaration.signature
        let methodParameters = methodSignature.parameterClause.parameters

        var backingType: String
        var backingGenericArguments: [String] = []
        var didTypeEraseReturnType = false

        if let returnClause = methodSignature.returnClause {
            let (returnType, didTypeErase) = self.mockMethodOverrideDeclarationType(
                returnClause.type,
                typeErasedIfNecessaryUsing: methodGenericParameters
            )

            backingType = "MockReturning"
            backingGenericArguments.append(returnType.trimmedDescription)
            didTypeEraseReturnType = didTypeErase
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
            let elements = arguments.elements.map { element in
                let (elementType, _) = self.mockMethodOverrideDeclarationType(
                    element.type,
                    typeErasedIfNecessaryUsing: methodGenericParameters
                )

                return element.with(\.type, elementType.trimmed)
            }
            let arguments = arguments.with(\.elements, TupleTypeElementListSyntax(elements))

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
                modifiers: self.mockOverrideDeclarationModifiers(
                    from: methodDeclaration.modifiers,
                    with: AccessLevelSyntax.private,
                    in: protocolDeclaration
                ),
                .let,
                name: PatternSyntax(
                    stringLiteral: "__\(methodName)"
                ),
                initializer: InitializerClauseSyntax(
                    value: ExprSyntax(stringLiteral: backingMethodInitializerValue)
                )
            ),
            exposedMethod: VariableDeclSyntax(
                modifiers: self.mockOverrideDeclarationModifiers(
                    from: methodDeclaration.modifiers,
                    with: accessLevel,
                    in: protocolDeclaration
                ),
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
            ),
            didTypeEraseReturnType: didTypeEraseReturnType
        )
    }

    /// Returns a copy of the provided `type` to use in a mock's method override
    /// declaration, type-erased if necessary based on the provided
    /// `genericParameters` pulled from the method conformance declaration that
    /// is being backed by the override declaration.
    ///
    /// If a mock's method conformance declaration contains generic parameters,
    /// those generic parameters can only be used within the scope of the mock's
    /// method conformance declaration. They cannot be used to specialize the
    /// method override declarations that are backing the conformance
    /// declaration as they are only scoped to the conformance declaration.
    ///
    /// For a type syntax that contains nested types, this method recursively
    /// calls itself on each nested type syntax until all nested types within
    /// the syntax tree are type-erased (if necessary).
    ///
    /// - Parameters:
    ///   - type: The type with which to specialize the mock's method override
    ///     declaration.
    ///   - genericParameters: The generic parameters pulled from the method
    ///     conformance declaration that is being backed by the method override
    ///     declaration.
    ///   - typeErasedType: The type-erased type to use to type-erase the
    ///     provided `type`. The default value is `Any.self`.
    /// - Returns: A copy of the provided `type` to use in a mock's method
    ///   override declaration, type-erased if necessary based on the provided
    ///   `genericParameters` pulled from the method conformance declaration
    ///   that is being backed by the override declaration.
    private static func mockMethodOverrideDeclarationType<TypeErasedType>(
        _ type: any TypeSyntaxProtocol,
        typeErasedIfNecessaryUsing genericParameters: GenericParameterListSyntax?,
        typeErasedType: TypeErasedType.Type = Any.self
    ) -> (
        newType: TypeSyntax,
        didTypeErase: Bool
    ) {
        let type = TypeSyntax(type)
        let result: (newType: any TypeSyntaxProtocol, didTypeErase: Bool)

        switch type.as(TypeSyntaxEnum.self) {
        case let .arrayType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.element,
                ifTypeIsContainedIn: genericParameters
            )
        case let .attributedType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.baseType,
                ifTypeIsContainedIn: genericParameters
            )
        case let .classRestrictionType(type):
            result = (newType: type, didTypeErase: false)
        case let .compositionType(type):
            result = self.syntax(
                type,
                withElementsInCollectionAt: \.elements,
                typeErasedAt: \.type,
                ifTypeIsContainedIn: genericParameters
            )
        case var .dictionaryType(type):
            let didTypeEraseKey, didTypeEraseValue: Bool

            (type, didTypeEraseKey) = self.syntax(
                type,
                typeErasedAt: \.key,
                ifTypeIsContainedIn: genericParameters,
                typeErasedType: AnyHashable.self
            )
            (type, didTypeEraseValue) = self.syntax(
                type,
                typeErasedAt: \.value,
                ifTypeIsContainedIn: genericParameters
            )

            result = (
                newType: type,
                didTypeErase: didTypeEraseKey || didTypeEraseValue
            )
        case var .functionType(type):
            let didTypeEraseParameters, didTypeEraseReturnValue: Bool

            (type, didTypeEraseParameters) = self.syntax(
                type,
                withElementsInCollectionAt: \.parameters,
                typeErasedAt: \.type,
                ifTypeIsContainedIn: genericParameters
            )
            (type, didTypeEraseReturnValue) = self.syntax(
                type,
                typeErasedAt: \.returnClause.type,
                ifTypeIsContainedIn: genericParameters
            )

            result = (
                newType: type,
                didTypeErase: didTypeEraseParameters || didTypeEraseReturnValue
            )
        case let .identifierType(type):
            if let genericParameter = genericParameters?.first(where: { genericParameter in
                genericParameter.name.tokenKind == type.name.tokenKind
            }) {
                let newType: any TypeSyntaxProtocol

                if typeErasedType == Any.self, let inheritedType = genericParameter.inheritedType {
                    let anySpecifier = TokenSyntax(
                        .keyword(.any),
                        trailingTrivia: .space,
                        presence: .present
                    )

                    newType = SomeOrAnyTypeSyntax(
                        someOrAnySpecifier: anySpecifier,
                        constraint: inheritedType
                    )
                } else {
                    newType = TypeSyntax(describing: typeErasedType)
                }

                result = (newType: newType, didTypeErase: true)
            } else {
                result = self.type(
                    type,
                    typeErasedIfAnyArgumentsIn: \.genericArgumentClause,
                    areContainedIn: genericParameters,
                    typeErasedType: typeErasedType
                )
            }
        case let .implicitlyUnwrappedOptionalType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.wrappedType,
                ifTypeIsContainedIn: genericParameters
            )
        case let .memberType(type) where type.name.tokenKind == .keyword(.self):
            result = self.syntax(
                type,
                typeErasedAt: \.baseType,
                ifTypeIsContainedIn: genericParameters
            )
        case let .memberType(type):
            result = self.type(
                type,
                typeErasedIfAnyArgumentsIn: \.genericArgumentClause,
                areContainedIn: genericParameters,
                typeErasedType: typeErasedType
            )
        case let .metatypeType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.baseType,
                ifTypeIsContainedIn: genericParameters
            )
        case let .missingType(type):
            result = (newType: type, didTypeErase: false)
        case let .namedOpaqueReturnType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.type,
                ifTypeIsContainedIn: genericParameters
            )
        case let .optionalType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.wrappedType,
                ifTypeIsContainedIn: genericParameters
            )
        case let .packElementType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.pack,
                ifTypeIsContainedIn: genericParameters
            )
        case let .packExpansionType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.repetitionPattern,
                ifTypeIsContainedIn: genericParameters
            )
        case let .someOrAnyType(type):
            let anySpecifier = TokenSyntax(
                .keyword(.any),
                trailingTrivia: .space,
                presence: .present
            )

            result = self.syntax(
                type.with(\.someOrAnySpecifier, anySpecifier),
                typeErasedAt: \.constraint,
                ifTypeIsContainedIn: genericParameters
            )
        case let .suppressedType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.type,
                ifTypeIsContainedIn: genericParameters
            )
        case let .tupleType(type):
            result = self.syntax(
                type,
                withElementsInCollectionAt: \.elements,
                typeErasedAt: \.type,
                ifTypeIsContainedIn: genericParameters
            )
        }

        let newType = TypeSyntax(result.newType)

        return (newType, result.didTypeErase)
    }

    /// Returns a tuple containing a copy of the provided `syntax`, type-erased
    /// at the provided `typeKeyPath` if the type is contained in the provided
    /// `genericParameters`, and a Boolean value indicating whether the `syntax`
    /// was type-erased at the provided `typeKeyPath`.
    ///
    /// - Parameters:
    ///   - syntax: The syntax that contains the type to type-erase.
    ///   - typeKeyPath: The key path at which the type is located in the
    ///     provided `syntax`.
    ///   - genericParameters: The generic parameters which, depending on
    ///     whether they contain the type at the provided `typeKeyPath`,
    ///     determine whether the type gets type-erased.
    ///   - typeErasedType: The type-erased type to use to type-erase the type
    ///     at the provided `typeKeyPath`. The default value is `Any.self`.
    /// - Returns: A tuple containing a copy of the provided `syntax`, type-
    ///   erased at the provided `typeKeyPath` if the type is contained in the
    ///   provided `genericParameters`, and a Boolean value indicating whether
    ///   the `syntax` was type-erased at the provided `typeKeyPath`.
    private static func syntax<Syntax: SyntaxProtocol, TypeErasedType>(
        _ syntax: Syntax,
        typeErasedAt typeKeyPath: WritableKeyPath<Syntax, TypeSyntax>,
        ifTypeIsContainedIn genericParameters: GenericParameterListSyntax?,
        typeErasedType: TypeErasedType.Type = Any.self
    ) -> (Syntax, Bool) {
        let (type, didTypeErase) = self.mockMethodOverrideDeclarationType(
            syntax[keyPath: typeKeyPath],
            typeErasedIfNecessaryUsing: genericParameters,
            typeErasedType: typeErasedType
        )
        let newSyntax = syntax.with(typeKeyPath, type)

        return (newSyntax, didTypeErase)
    }

    /// Returns a tuple containing a copy of the provided `syntax`, with the
    /// elements in the collection at the provided `collectionKeyPath` type-
    /// erased at the provided `typeKeyPath` if the type is contained in the
    /// provided `genericParameters`, and a Boolean value indicating whether any
    /// of the collection's elements were type-erased.
    ///
    /// If a type is contained in the provided `genericParameters`, this method
    /// erases that type to `Any`.
    ///
    /// - Parameters:
    ///   - syntax: The syntax that contains the collection.
    ///   - collectionKeyPath: The key path at which the collection is located
    ///     in the provided `syntax`.
    ///   - typeKeyPath: The key path at which the type is located in an element
    ///     in the syntax's collection.
    ///   - genericParameters: The generic parameters which, depending on
    ///     whether they contain an element's type, determine whether that
    ///     element gets type-erased.
    /// - Returns: A tuple containing a copy of the provided `syntax`, with the
    ///   elements in the collection at the provided `collectionKeyPath` type-
    ///   erased at the provided `typeKeyPath` if the type is contained in the
    ///   provided `genericParameters`, and a Boolean value indicating whether
    ///   any of the collection's elements were type-erased.
    private static func syntax<Syntax: SyntaxProtocol, Collection: SyntaxCollection>(
        _ syntax: Syntax,
        withElementsInCollectionAt collectionKeyPath: WritableKeyPath<Syntax, Collection>,
        typeErasedAt typeKeyPath: WritableKeyPath<Collection.Element, TypeSyntax>,
        ifTypeIsContainedIn genericParameters: GenericParameterListSyntax?
    ) -> (Syntax, Bool) {
        self.syntax(
            syntax,
            withElementsInCollectionAt: collectionKeyPath,
            typeErasedAt: typeKeyPath,
            ifTypeIsContainedIn: genericParameters
        ) { _ in
            Any.self
        }
    }

    /// Returns a tuple containing a copy of the provided `syntax`, with the
    /// elements in the collection at the provided `collectionKeyPath` type-
    /// erased at the provided `typeKeyPath` if the type is contained in the
    /// provided `genericParameters`, and a Boolean value indicating whether any
    /// of the collection's elements were type-erased.
    ///
    /// If a type is contained in the provided `genericParameters`, this method
    /// uses the provided `typeErasedType` closure to request the type-erased
    /// type to use to erase the type.
    ///
    /// - Parameters:
    ///   - syntax: The syntax that contains the collection.
    ///   - collectionKeyPath: The key path at which the collection is located
    ///     in the provided `syntax`.
    ///   - typeKeyPath: The key path at which the type is located in an element
    ///     in the syntax's collection.
    ///   - genericParameters: The generic parameters which, depending on
    ///     whether they contain an element's type, determine whether that
    ///     element gets type-erased.
    ///   - typeErasedType: A closure that takes the index of an element in the
    ///     collection and returns the type-erased type to use to type-erase the
    ///     element.
    /// - Returns: A tuple containing a copy of the provided `syntax`, with the
    ///   elements in the collection at the provided `collectionKeyPath` type-
    ///   erased at the provided `typeKeyPath` if the type is contained in the
    ///   provided `genericParameters`, and a Boolean value indicating whether
    ///   any of the collection's elements were type-erased.
    private static func syntax<Syntax: SyntaxProtocol, Collection: SyntaxCollection>(
        _ syntax: Syntax,
        withElementsInCollectionAt collectionKeyPath: WritableKeyPath<Syntax, Collection>,
        typeErasedAt typeKeyPath: WritableKeyPath<Collection.Element, TypeSyntax>,
        ifTypeIsContainedIn genericParameters: GenericParameterListSyntax?,
        typeErasedType: (Int) -> Any.Type
    ) -> (Syntax, Bool) {
        var newElements: [Collection.Element] = []
        var didTypeErase = false

        for (index, element) in syntax[keyPath: collectionKeyPath].enumerated() {
            let (newElement, didTypeEraseElement) = self.syntax(
                element,
                typeErasedAt: typeKeyPath,
                ifTypeIsContainedIn: genericParameters,
                typeErasedType: typeErasedType(index)
            )

            newElements.append(newElement)
            didTypeErase = didTypeErase || didTypeEraseElement
        }

        let newCollection = Collection(newElements)
        let newSyntax = syntax.with(collectionKeyPath, newCollection)

        return (newSyntax, didTypeErase)
    }

    /// Returns a tuple containing a copy of the provided type, type-erased if
    /// any arguments in the type's generic argument clause at the provided
    /// `genericArgumentClauseKeyPath` are contained in the provided
    /// `genericParameters`, and a Boolean value indicating whether the type or
    /// any of its generic arguments were type-erased.
    ///
    /// For some generic Swift types, such as `Array`, `Dictionary`, `Optional`,
    /// and `Set`, this method type-erases the generic arguments in the type's
    /// generic argument clause to maintain some level of type-safety. For other
    /// generic types, this method type-erases the entire type to the provided
    /// `typeErasedType`.
    ///
    /// - Parameters:
    ///   - type: The type syntax to type-erase.
    ///   - genericArgumentClauseKeyPath: The key path at which the generic
    ///     argument clause is located in the provided `type`.
    ///   - genericParameters: The generic parameters which, depending on
    ///     whether they contain a generic argument from the type's generic
    ///     argument clause, determine whether that generic argument or the type
    ///     gets type-erased.
    ///   - typeErasedType: The type-erased type to use to type-erase the type.
    /// - Returns: A tuple containing a copy of the provided type, type-erased
    ///   if any arguments in the type's generic argument clause at the provided
    ///   `genericArgumentClauseKeyPath` are contained in the provided
    ///   `genericParameters`, and a Boolean value indicating whether the type
    ///   or any of its generic arguments were type-erased.
    private static func type<Syntax: TypeSyntaxProtocol, TypeErasedType>(
        _ type: Syntax,
        typeErasedIfAnyArgumentsIn genericArgumentClauseKeyPath: KeyPath<
            Syntax,
            GenericArgumentClauseSyntax?
        >,
        areContainedIn genericParameters: GenericParameterListSyntax?,
        typeErasedType: TypeErasedType.Type
    ) -> (
        newType: any TypeSyntaxProtocol,
        didTypeErase: Bool
    ) {
        guard let genericArgumentClause = type[keyPath: genericArgumentClauseKeyPath] else {
            return (newType: type, didTypeErase: false)
        }

        switch TypeSyntax(type).as(TypeSyntaxEnum.self) {
        case let .identifierType(type) where self.identifierType(
            type,
            isNamed: "Optional", "Array"
        ):
            let (newGenericArgumentClause, didTypeErase) = self.syntax(
                genericArgumentClause,
                withElementsInCollectionAt: \.arguments,
                typeErasedAt: \.argument,
                ifTypeIsContainedIn: genericParameters
            )
            let newType = type.with(\.genericArgumentClause, newGenericArgumentClause)

            return (newType, didTypeErase)
        case let .identifierType(type) where self.identifierType(
            type,
            isNamed: "Set", "Dictionary"
        ):
            let (newGenericArgumentClause, didTypeErase) = self.syntax(
                genericArgumentClause,
                withElementsInCollectionAt: \.arguments,
                typeErasedAt: \.argument,
                ifTypeIsContainedIn: genericParameters
            ) { index in
                index == .zero ? AnyHashable.self : Any.self
            }
            let newType = type.with(\.genericArgumentClause, newGenericArgumentClause)

            return (newType, didTypeErase)
        case let .memberType(type) where self.memberType(
            type,
            isNamed: "Optional", "Array",
            withBaseTypeNamed: "Swift"
        ):
            let (newGenericArgumentClause, didTypeErase) = self.syntax(
                genericArgumentClause,
                withElementsInCollectionAt: \.arguments,
                typeErasedAt: \.argument,
                ifTypeIsContainedIn: genericParameters
            )
            let newType = type.with(\.genericArgumentClause, newGenericArgumentClause)

            return (newType, didTypeErase)
        case let .memberType(type) where self.memberType(
            type,
            isNamed: "Set", "Dictionary",
            withBaseTypeNamed: "Swift"
        ):
            let (newGenericArgumentClause, didTypeErase) = self.syntax(
                genericArgumentClause,
                withElementsInCollectionAt: \.arguments,
                typeErasedAt: \.argument,
                ifTypeIsContainedIn: genericParameters
            ) { index in
                index == .zero ? AnyHashable.self : Any.self
            }
            let newType = type.with(\.genericArgumentClause, newGenericArgumentClause)

            return (newType, didTypeErase)
        default:
            let (_, didTypeErase) = self.syntax(
                genericArgumentClause,
                withElementsInCollectionAt: \.arguments,
                typeErasedAt: \.argument,
                ifTypeIsContainedIn: genericParameters
            )

            let newType: any TypeSyntaxProtocol = if didTypeErase {
                TypeSyntax(describing: typeErasedType)
            } else {
                type
            }

            return (newType, didTypeErase)
        }
    }

    /// Returns a Boolean value indicating whether the provided identifier
    /// type's name matches any of the provided `names`.
    ///
    /// - Parameters:
    ///   - type: An identifier type.
    ///   - names: The names to compare to the provided `type`'s name.
    /// - Returns: A Boolean value indicating whether the provided identifier
    ///   type's name matches any of the provided `names`.
    private static func identifierType(
        _ type: IdentifierTypeSyntax,
        isNamed names: String...
    ) -> Bool {
        names.contains { type.name.tokenKind == .identifier($0) }
    }

    /// Returns a Boolean value indicating whether the provided member type's
    /// name matches any of the provided `names` and base type's name matches
    /// the provided `baseTypeName`.
    ///
    /// - Parameters:
    ///   - type: A member type.
    ///   - names: The names to compare to the provided `type`'s name.
    ///   - baseTypeName: The name to compare to the provided `type`'s base
    ///     type's name.
    /// - Returns: A Boolean value indicating whether the provided member type's
    ///   name matches any of the provided `names` and base type's name matches
    ///   the provided `baseTypeName`.
    private static func memberType(
        _ type: MemberTypeSyntax,
        isNamed names: String...,
        withBaseTypeNamed baseTypeName: String
    ) -> Bool {
        guard let baseType = type.baseType.as(IdentifierTypeSyntax.self) else {
            return false
        }

        return baseType.name.tokenKind == .identifier(baseTypeName)
            && names.contains { type.name.tokenKind == .identifier($0) }
    }

    /// Returns a method conformance declaration to apply to the mock, generated
    /// from the provided protocol method and marked with the provided access
    /// level.
    ///
    /// - Parameters:
    ///   - accessLevel: The access level to apply to the method conformance
    ///     declaration.
    ///   - methodDeclaration: A method from the protocol to which the mock must
    ///     conform.
    ///   - didTypeEraseOverrideDeclarationsReturnType: A Boolean value
    ///     indicating whether the override declarations' return type had to be
    ///     type-erased.
    /// - Returns: A method conformance declaration to apply to the mock.
    private static func mockMethodConformanceDeclaration(
        with accessLevel: AccessLevelSyntax,
        for methodDeclaration: FunctionDeclSyntax,
        didTypeEraseOverrideDeclarationsReturnType: Bool
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
                .map(\.trimmed.text)
                .joined(separator: ", ")

            backingImplementationInvocation += "((\(joinedInvocationArguments)))"
        }

        return try methodDeclaration
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
            .with(\.body) {
                if
                    didTypeEraseOverrideDeclarationsReturnType,
                    let returnType = methodDeclaration.signature.returnClause?.type.trimmed
                {
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
                    """
                    "return value"
                } else {
                    "\(raw: backingImplementationInvocation)"
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

    // MARK: Reset Static Members Method

    /// Returns a `resetMockedStaticMembers` method declaration that, when
    /// invoked, resets the `static` backing override declarations generated by
    /// `Mocked`, contained in the provided `backingOverrideDeclarations`
    /// collection.
    ///
    /// - Parameters:
    ///   - backingOverrideDeclarations: The backing override declarations
    ///     generated by `Mocked`.
    ///   - protocolDeclaration: The protocol to which the mock must conform.
    /// - Returns: A `resetMockedStaticMembers` method declaration that, when
    ///   invoked, resets the `static` backing override declarations generated
    ///   by `Mocked`, contained in the provided `backingOverrideDeclarations`
    ///   collection.
    private static func resetMockedStaticMembersMethodDeclaration(
        backingOverrideDeclarations: [VariableDeclSyntax],
        protocolDeclaration: ProtocolDeclSyntax
    ) -> FunctionDeclSyntax? {
        let staticBackingOverrideDeclarations = backingOverrideDeclarations
            .filter { declaration in
                declaration.modifiers.contains { modifier in
                    modifier.name.tokenKind == .keyword(.static)
                }
            }

        guard !staticBackingOverrideDeclarations.isEmpty else {
            return nil
        }

        return FunctionDeclSyntax(
            leadingTrivia: """
            /// Resets the implementations and invocation records of the mock's static
            /// properties and methods.\n
            """,
            modifiers: DeclModifierListSyntax {
                if protocolDeclaration.accessLevel != .internal {
                    protocolDeclaration.accessLevel.modifier
                }

                DeclModifierSyntax(name: .keyword(.static))
            },
            funcKeyword: .keyword(.func),
            name: .identifier("resetMockedStaticMembers"),
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(
                    leftParen: .leftParenToken(),
                    rightParen: .rightParenToken()
                ) {}
            )
        ) {
            for staticBackingOverrideDeclaration in staticBackingOverrideDeclarations {
                if let binding = staticBackingOverrideDeclaration.bindings.first {
                    let bindingName = binding.pattern.trimmed

                    "self.\(bindingName).reset()"
                }
            }
        }
    }
}
