//
//  MockedMembersMacro+MockMethodNameComponent+Constructors.swift
//  MockedMacros
//
//  Created by Gray Campbell on 1/29/25.
//

#if compiler(>=5.8)
@_spi(ExperimentalLanguageFeatures)
#endif
import SwiftSyntax

extension MockedMembersMacro.MockMethodNameComponent {

    // MARK: Constructors

    /// Returns a `methodName` component parsed from the provided
    /// `methodDeclaration`.
    ///
    /// - Parameter methodDeclaration: The method declaration from which to
    ///   parse the `methodName` component.
    /// - Returns: A `methodName` component parsed from the provided
    ///   `methodDeclaration`.
    static func name(
        from methodDeclaration: FunctionDeclSyntax
    ) -> Self {
        Self(
            id: .methodName,
            order: .zero,
            value: methodDeclaration.name.trimmedDescription
        )
    }

    /// Returns a `parameterName` component parsed from the provided `parameter`
    /// at the provided `index`.
    ///
    /// - Parameters:
    ///   - parameter: The method parameter from which to parse the
    ///     `parameterName` component.
    ///   - index: The index of the parameter in the method's parameter clause.
    /// - Returns: A `parameterName` component parsed from the provided
    ///   `parameter` at the provided `index`.
    static func name(
        from parameter: FunctionParameterSyntax,
        at index: Int
    ) -> Self {
        var value = self.capitalizedDescription(of: parameter.firstName)

        if let secondName = parameter.secondName {
            value += self.capitalizedDescription(of: secondName)
        }

        return Self(
            id: .parameterName(index),
            order: index + 1,
            value: value
        )
    }

    /// Returns a `parameterType` component parsed from the provided `parameter`
    /// at the provided `index`.
    ///
    /// - Parameters:
    ///   - parameter: The method parameter from which to parse the
    ///     `parameterType` component.
    ///   - index: The index of the parameter in the method's parameter clause.
    /// - Returns: A `parameterType` component parsed from the provided
    ///   `parameter` at the provided `index`.
    static func type(
        from parameter: FunctionParameterSyntax,
        at index: Int
    ) -> Self {
        Self(
            id: .parameterType(index),
            order: index + (index + 2),
            value: self.capitalizedDescription(of: parameter.type)
        )
    }

    /// Returns a `returnType` component parsed from the provided `signature`,
    /// or `nil` if there isn't one.
    ///
    /// - Parameter signature: The method signature from which to parse the
    ///   `returnType` component.
    /// - Returns: A `returnType` component parsed from the provided
    ///   `signature`, or `nil` if there isn't one.
    static func returnType(
        from signature: FunctionSignatureSyntax
    ) -> Self? {
        // FIXME: Also return nil if return type is explicit Void or ()
        guard let returnClause = signature.returnClause else {
            return nil
        }

        return Self(
            id: .returnType,
            order: signature.parameterClause.parameters.count + 1,
            value: "Returning" + self.capitalizedDescription(of: returnClause.type)
        )
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
        let value = token.trimmedDescription
        let firstCharacter = value.prefix(1).capitalized
        let remainingCharacters = value.dropFirst()

        return String(firstCharacter) + String(remainingCharacters)
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
        case .missingType:
            "Missing"
        case let .namedOpaqueReturnType(type):
            // TODO: Description of type
            ""
        case let .optionalType(type):
            self.capitalizedDescription(of: type)
        case let .packElementType(type):
            // TODO: Description of type
            ""
        case let .packExpansionType(type):
            // TODO: Description of type
            ""
        case let .someOrAnyType(type):
            self.capitalizedDescription(of: type)
        case let .suppressedType(type):
            self.capitalizedDescription(of: type.type)
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

        return "DictionaryOf" + valueDescription + "KeyedBy" + keyDescription
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

        let isVoid: (TypeSyntax) -> Bool = { type in
            switch type.as(TypeSyntaxEnum.self) {
            case let .identifierType(type):
                type.name.tokenKind == .identifier("Void")
            case let .tupleType(type):
                type.elements.isEmpty
            default:
                false
            }
        }

        if isVoid(type.returnClause.type) {
            description = "Void" + description
        } else {
            let returnTypeDescription = self.capitalizedDescription(
                of: type.returnClause.type
            )

            description += "Returning" + returnTypeDescription
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
