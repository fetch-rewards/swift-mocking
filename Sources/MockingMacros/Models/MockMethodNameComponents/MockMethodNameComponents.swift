//
//  MockMethodNameComponents.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

#if compiler(>=5.8)
@_spi(ExperimentalLanguageFeatures)
#endif
import SwiftSyntax

/// A mock method's name components.
struct MockMethodNameComponents {

    // MARK: Properties

    /// The name components in order of when they get added to the mock method's
    /// full name.
    private let components: [MockMethodNameComponent]

    /// The full name derived from the name components.
    var fullName: String {
        self.name(to: self.components.endIndex - 1)
    }

    // MARK: Initializers

    /// Creates name components from the provided `methodDeclaration`.
    ///
    /// - Parameter methodDeclaration: The method declaration from which to
    ///   parse name components.
    init(methodDeclaration: FunctionDeclSyntax) {
        let signature = methodDeclaration.signature
        let parameters = signature.parameterClause.parameters

        var components: [MockMethodNameComponent] = [
            MockMethodNameComponent(
                id: .methodName,
                value: methodDeclaration.name.trimmedDescription,
                insertionIndex: .zero
            ),
        ]

        for (index, parameter) in parameters.enumerated() {
            var value = Self.capitalizedDescription(of: parameter.firstName)

            if let secondName = parameter.secondName {
                value += Self.capitalizedDescription(of: secondName)
            }

            components.append(
                MockMethodNameComponent(
                    id: .parameterName(index),
                    value: value,
                    insertionIndex: index + 1
                )
            )
        }

        if
            let returnClause = signature.returnClause,
            let returnClauseDescription = Self.capitalizedDescription(of: returnClause)
        {
            components.append(
                MockMethodNameComponent(
                    id: .returnType,
                    value: returnClauseDescription,
                    insertionIndex: components.endIndex
                )
            )
        }

        for (index, parameter) in parameters.enumerated() {
            let parameterNameDescription = Self.capitalizedDescription(
                of: parameter.secondName ?? parameter.firstName
            )
            var parameterTypeDescription = Self.capitalizedDescription(
                of: parameter.type
            )

            if parameterTypeDescription == parameterNameDescription {
                parameterTypeDescription = ""
            }

            components.append(
                MockMethodNameComponent(
                    id: .parameterType(index),
                    value: parameterTypeDescription,
                    insertionIndex: index + (index + 2)
                )
            )
        }

        if let effectSpecifiers = signature.effectSpecifiers {
            if let asyncSpecifier = effectSpecifiers.asyncSpecifier {
                components.append(
                    MockMethodNameComponent(
                        id: .asyncSpecifier,
                        value: Self.capitalizedDescription(of: asyncSpecifier),
                        insertionIndex: components.endIndex
                    )
                )
            }

            if let throwsSpecifier = effectSpecifiers.throwsClause?.throwsSpecifier {
                components.append(
                    MockMethodNameComponent(
                        id: .throwsSpecifier,
                        value: Self.capitalizedDescription(of: throwsSpecifier),
                        insertionIndex: components.endIndex
                    )
                )
            }
        }

        var genericRequirementIndex: Int = .zero
        var genericRequirementDescriptionPrefix = "Where"
        let appendGenericRequirementDescription: (String) -> Void = { description in
            components.append(
                MockMethodNameComponent(
                    id: .genericRequirement(genericRequirementIndex),
                    value: genericRequirementDescriptionPrefix + description,
                    insertionIndex: components.endIndex
                )
            )
            genericRequirementIndex += 1
            genericRequirementDescriptionPrefix = ""
        }

        if let genericParameterClause = methodDeclaration.genericParameterClause {
            for genericParameter in genericParameterClause.parameters {
                if genericParameter.inheritedType != nil {
                    appendGenericRequirementDescription(
                        Self.capitalizedDescription(of: genericParameter)
                    )
                }
            }
        }

        if let genericWhereClause = methodDeclaration.genericWhereClause {
            for genericRequirement in genericWhereClause.requirements {
                let genericRequirementDescription = switch genericRequirement.requirement {
                case let .conformanceRequirement(requirement):
                    Self.capitalizedDescription(of: requirement)
                case let .layoutRequirement(requirement):
                    Self.capitalizedDescription(of: requirement)
                case let .sameTypeRequirement(requirement):
                    Self.capitalizedDescription(of: requirement)
                }

                appendGenericRequirementDescription(genericRequirementDescription)
            }
        }

        self.components = components
    }

    // MARK: Name

    /// Returns the name derived from the name components up to and including
    /// the component at the provided `index`.
    ///
    /// If the provided `index` is out-of-bounds, this method clamps it to a
    /// valid range of indices.
    ///
    /// - Parameter index: The index of the last name component to include in
    ///   the returned name.
    /// - Returns: The name derived from the name components up to and including
    ///   the component at the provided `index`.
    func name(to index: Int) -> String {
        let clampedIndex = max(.zero, min(index, self.components.endIndex - 1))
        let components = self.components[.zero...clampedIndex]

        let values = components.reduce(into: [String]()) { result, component in
            result.insert(component.value, at: component.insertionIndex)
        }

        return values.joined()
    }
}

// MARK: - Helpers

extension MockMethodNameComponents {

    // MARK: Is Void

    /// Returns a Boolean value indicating whether the provided `type` is `Void`
    /// or `()`.
    ///
    /// - Parameter type: A type syntax.
    /// - Returns: A Boolean value indicating whether the provided `type` is
    ///   `Void` or `()`.
    private static func isVoidType(_ type: TypeSyntax) -> Bool {
        switch type.as(TypeSyntaxEnum.self) {
        case let .identifierType(type):
            type.name.tokenKind == .identifier("Void")
        case let .tupleType(type):
            type.elements.isEmpty
        default:
            false
        }
    }

    // MARK: Capitalized Description

    /// Returns a capitalized description of the provided `token`.
    ///
    /// - Parameter token: The token syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `token`.
    private static func capitalizedDescription(
        of token: TokenSyntax
    ) -> String {
        token.trimmedDescription.withFirstCharacterCapitalized()
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: any TypeSyntaxProtocol
    ) -> String {
        switch TypeSyntax(type).as(TypeSyntaxEnum.self) {
        case let .arrayType(type):
            self.capitalizedDescription(of: type)
        case let .attributedType(type):
            self.capitalizedDescription(of: type)
        case let .classRestrictionType(type):
            self.capitalizedDescription(of: type.classKeyword)
        case let .compositionType(type):
            self.capitalizedDescription(of: type)
        case let .dictionaryType(type):
            self.capitalizedDescription(of: type)
        case let .functionType(type):
            self.capitalizedDescription(of: type)
        case let .identifierType(type):
            self.capitalizedDescription(of: type)
        case let .implicitlyUnwrappedOptionalType(type):
            self.capitalizedDescription(of: type)
        case let .memberType(type):
            self.capitalizedDescription(of: type)
        case let .metatypeType(type):
            self.capitalizedDescription(of: type)
        case let .missingType(type):
            self.capitalizedDescription(of: type)
        case let .namedOpaqueReturnType(type):
            self.capitalizedDescription(of: type)
        case let .optionalType(type):
            self.capitalizedDescription(of: type)
        case let .packElementType(type):
            self.capitalizedDescription(of: type)
        case let .packExpansionType(type):
            self.capitalizedDescription(of: type)
        case let .someOrAnyType(type):
            self.capitalizedDescription(of: type)
        case let .suppressedType(type):
            self.capitalizedDescription(of: type)
        case let .tupleType(type):
            self.capitalizedDescription(of: type)
        }
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The array type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: ArrayTypeSyntax
    ) -> String {
        "ArrayOf" + self.capitalizedDescription(of: type.element)
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The attributed type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: AttributedTypeSyntax
    ) -> String {
        let specifiersDescription = type.specifiers.reduce(into: "") { result, specifier in
            switch specifier {
            case let .simpleTypeSpecifier(specifier):
                result += self.capitalizedDescription(of: specifier.specifier)
            case let .lifetimeTypeSpecifier(specifier):
                result += self.capitalizedDescription(of: specifier.dependsOnKeyword)

                if let scopedKeyword = specifier.scopedKeyword {
                    result += self.capitalizedDescription(of: scopedKeyword)
                }

                result += specifier.arguments.reduce("") { result, argument in
                    result + self.capitalizedDescription(of: argument.parameter)
                }
            }
        }
        let baseTypeDescription = self.capitalizedDescription(of: type.baseType)

        return specifiersDescription + baseTypeDescription
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The composition type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: CompositionTypeSyntax
    ) -> String {
        type.elements.reduce("") { result, element in
            result + self.capitalizedDescription(of: element.type)
        }
    }

    /// Returns a capitalized description of the provided `requirement`.
    ///
    /// - Parameter type: The conformance requirement syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `requirement`.
    private static func capitalizedDescription(
        of requirement: ConformanceRequirementSyntax
    ) -> String {
        let leftTypeDescription = self.capitalizedDescription(of: requirement.leftType)
        let rightTypeDescription = self.capitalizedDescription(of: requirement.rightType)

        return leftTypeDescription + rightTypeDescription
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The dictionary type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: DictionaryTypeSyntax
    ) -> String {
        let keyDescription = self.capitalizedDescription(of: type.key)
        let valueDescription = self.capitalizedDescription(of: type.value)

        return "DictionaryOf" + keyDescription + "To" + valueDescription
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The function type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: FunctionTypeSyntax
    ) -> String {
        var description = "Closure"

        if !type.parameters.isEmpty {
            let parametersDescription = type.parameters.reduce("") { result, parameter in
                result + self.capitalizedDescription(of: parameter)
            }

            description += "With" + parametersDescription
        }

        if let returnClauseDescription = self.capitalizedDescription(
            of: type.returnClause
        ) {
            description += returnClauseDescription
        }

        return description
    }

    /// Returns a capitalized description of the provided
    /// `genericArgumentClause`, or `nil` if the provided
    /// `genericArgumentClause` is `nil` or empty.
    ///
    /// - Parameter genericArgumentClause: The generic argument clause syntax to
    ///   describe.
    ///
    /// - Returns: A capitalized description of the provided
    ///   `genericArgumentClause`, or `nil` if the provided
    ///   `genericArgumentClause` is `nil` or empty.
    private static func capitalizedDescription(
        of genericArgumentClause: GenericArgumentClauseSyntax?
    ) -> String? {
        guard
            let genericArgumentClause,
            !genericArgumentClause.arguments.isEmpty
        else {
            return nil
        }

        return genericArgumentClause.arguments.reduce("") { result, argument in
            result + self.capitalizedDescription(of: argument.argument)
        }
    }

    /// Returns a capitalized description of the provided `genericParameter`.
    ///
    /// - Parameter genericParameter: The generic parameter syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `genericParameter`.
    private static func capitalizedDescription(
        of genericParameter: GenericParameterSyntax
    ) -> String {
        let nameDescription = self.capitalizedDescription(of: genericParameter.name)

        guard let inheritedType = genericParameter.inheritedType else {
            return nameDescription
        }

        return nameDescription + self.capitalizedDescription(of: inheritedType)
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The identifier type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: IdentifierTypeSyntax
    ) -> String {
        guard
            case .identifier("Dictionary") = type.name.tokenKind,
            let genericArgumentClause = type.genericArgumentClause,
            let key = genericArgumentClause.arguments.first?.argument,
            let value = genericArgumentClause.arguments.last?.argument
        else {
            let nameDescription = self.capitalizedDescription(of: type.name)

            guard
                let genericArgumentsDescription = self.capitalizedDescription(
                    of: type.genericArgumentClause
                )
            else {
                return nameDescription
            }

            return nameDescription + "Of" + genericArgumentsDescription
        }

        return self.capitalizedDescription(
            of: DictionaryTypeSyntax(key: key, value: value)
        )
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The implicitly unwrapped optional type syntax to
    ///   describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: ImplicitlyUnwrappedOptionalTypeSyntax
    ) -> String {
        "Optional" + self.capitalizedDescription(of: type.wrappedType)
    }

    /// Returns a capitalized description of the provided `requirement`.
    ///
    /// - Parameter type: The layout requirement syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `requirement`.
    private static func capitalizedDescription(
        of requirement: LayoutRequirementSyntax
    ) -> String {
        let typeDescription = self.capitalizedDescription(of: requirement.type)
        let layoutSpecifierDescription = self.capitalizedDescription(
            of: requirement.layoutSpecifier
        )

        return typeDescription + layoutSpecifierDescription
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The member type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: MemberTypeSyntax
    ) -> String {
        let baseTypeDescription = self.capitalizedDescription(of: type.baseType)
        let nameDescription = self.capitalizedDescription(of: type.name)

        guard
            let genericArgumentClause = type.genericArgumentClause,
            let genericArgumentsDescription = self.capitalizedDescription(
                of: genericArgumentClause
            )
        else {
            return baseTypeDescription + nameDescription
        }

        guard
            let identifierBaseType = type.baseType.as(IdentifierTypeSyntax.self),
            identifierBaseType.name.tokenKind == .identifier("Swift"),
            type.name.tokenKind == .identifier("Dictionary"),
            let key = genericArgumentClause.arguments.first?.argument,
            let value = genericArgumentClause.arguments.last?.argument
        else {
            return baseTypeDescription + nameDescription + "Of" + genericArgumentsDescription
        }

        let dictionaryDescription = self.capitalizedDescription(
            of: DictionaryTypeSyntax(key: key, value: value)
        )

        return baseTypeDescription + dictionaryDescription
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The metatype type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: MetatypeTypeSyntax
    ) -> String {
        let baseTypeDescription = self.capitalizedDescription(of: type.baseType)
        let metatypeSpecifierDescription = self.capitalizedDescription(
            of: type.metatypeSpecifier
        )

        return baseTypeDescription + metatypeSpecifierDescription
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The missing type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: MissingTypeSyntax
    ) -> String {
        "Missing"
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The named opaque return type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: NamedOpaqueReturnTypeSyntax
    ) -> String {
        let genericParameters = type.genericParameterClause.parameters
        let genericParametersDescription = genericParameters.reduce("") { result, genericParameter in
            result + Self.capitalizedDescription(of: genericParameter)
        }
        let typeDescription = Self.capitalizedDescription(of: type.type)

        return genericParametersDescription + typeDescription
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The optional type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: OptionalTypeSyntax
    ) -> String {
        "Optional" + self.capitalizedDescription(of: type.wrappedType)
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The pack element type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: PackElementTypeSyntax
    ) -> String {
        let eachKeywordDescription = self.capitalizedDescription(of: type.eachKeyword)
        let packDescription = self.capitalizedDescription(of: type.pack)

        return eachKeywordDescription + packDescription
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The pack expansion type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: PackExpansionTypeSyntax
    ) -> String {
        let repeatKeywordDescription = self.capitalizedDescription(of: type.repeatKeyword)
        let repetitionPatternDescription = self.capitalizedDescription(
            of: type.repetitionPattern
        )

        return repeatKeywordDescription + repetitionPatternDescription
    }

    /// Returns a capitalized description of the provided `returnClause`, or
    /// `nil` if the return type is `Void` or `()`.
    ///
    /// - Parameter type: The return clause syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `returnClause`, or
    ///   `nil` if the return type is `Void` or `()`.
    private static func capitalizedDescription(
        of returnClause: ReturnClauseSyntax
    ) -> String? {
        guard !self.isVoidType(returnClause.type) else {
            return nil
        }

        return "Returning" + self.capitalizedDescription(of: returnClause.type)
    }

    /// Returns a capitalized description of the provided `requirement`.
    ///
    /// - Parameter type: The same-type requirement syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `requirement`.
    private static func capitalizedDescription(
        of requirement: SameTypeRequirementSyntax
    ) -> String {
        let leftTypeDescription = self.capitalizedDescription(of: requirement.leftType)
        let rightTypeDescription = self.capitalizedDescription(of: requirement.rightType)

        return leftTypeDescription + rightTypeDescription
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The `some` or `any` type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: SomeOrAnyTypeSyntax
    ) -> String {
        let specifierDescription = self.capitalizedDescription(of: type.someOrAnySpecifier)
        let constraintDescription = self.capitalizedDescription(of: type.constraint)

        return specifierDescription + constraintDescription
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The suppressed type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: SuppressedTypeSyntax
    ) -> String {
        "Non" + self.capitalizedDescription(of: type.type)
    }

    /// Returns a capitalized description of the provided `type`.
    ///
    /// - Parameter type: The tuple type syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `type`.
    private static func capitalizedDescription(
        of type: TupleTypeSyntax
    ) -> String {
        guard !type.elements.isEmpty else {
            return "Void"
        }

        let elementsDescription = type.elements.reduce("") { result, element in
            result + self.capitalizedDescription(of: element)
        }

        return "TupleOf" + elementsDescription
    }

    /// Returns a capitalized description of the provided `tupleElement`.
    ///
    /// - Parameter tupleElement: The tuple type element syntax to describe.
    ///
    /// - Returns: A capitalized description of the provided `tupleElement`.
    private static func capitalizedDescription(
        of tupleTypeElement: TupleTypeElementSyntax
    ) -> String {
        var description = ""

        if let inoutKeyword = tupleTypeElement.inoutKeyword {
            description += self.capitalizedDescription(of: inoutKeyword)
        }

        if tupleTypeElement.ellipsis != nil {
            description += "Variadic"
        }

        description += self.capitalizedDescription(of: tupleTypeElement.type)

        return description
    }
}
