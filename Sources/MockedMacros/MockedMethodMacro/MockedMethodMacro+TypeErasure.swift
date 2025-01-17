//
//  MockedMethodMacro+TypeErasure.swift
//  MockedMacros
//
//  Created by Gray Campbell on 1/14/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxSugar

extension MockedMethodMacro {

    /// Returns a copy of the provided `type`, type-erased if necessary using
    /// the provided `genericParameters` and `genericWhereClause`.
    ///
    /// For a type syntax that contains nested types, this method recursively
    /// calls itself on each nested type syntax until all nested types within
    /// the syntax tree are type-erased (if necessary).
    ///
    /// - Parameters:
    ///   - type: The type with which to specialize the method override
    ///     declaration.
    ///   - genericParameters: The generic parameters with which to determine
    ///     whether the type needs to be type-erased.
    ///   - genericWhereClause: The generic where clause with which to determine
    ///     how to constrain the type-erased type.
    ///   - typeErasedType: The type-erased type to use to type-erase the
    ///     provided `type`. The default value is `Any.self`.
    /// - Returns: A copy of the provided `type`, type-erased if necessary using
    ///   the provided `genericParameters` and `genericWhereClause`.
    static func type<TypeErasedType>(
        _ type: any TypeSyntaxProtocol,
        typeErasedIfNecessaryUsing genericParameters: GenericParameterListSyntax?,
        typeConstrainedBy genericWhereClause: GenericWhereClauseSyntax?,
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
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
        case let .attributedType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.baseType,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
        case let .classRestrictionType(type):
            result = (newType: type, didTypeErase: false)
        case let .compositionType(type):
            result = self.syntax(
                type,
                withElementsInCollectionAt: \.elements,
                typeErasedAt: \.type,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
        case var .dictionaryType(type):
            let didTypeEraseKey, didTypeEraseValue: Bool

            (type, didTypeEraseKey) = self.syntax(
                type,
                typeErasedAt: \.key,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause,
                typeErasedType: AnyHashable.self
            )
            (type, didTypeEraseValue) = self.syntax(
                type,
                typeErasedAt: \.value,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
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
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
            (type, didTypeEraseReturnValue) = self.syntax(
                type,
                typeErasedAt: \.returnClause.type,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
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

                if
                    typeErasedType == Any.self,
                    let inheritedType = self.inheritedType(
                        for: genericParameter,
                        typeConstrainedBy: genericWhereClause
                    )
                {
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
                    typeConstrainedBy: genericWhereClause,
                    typeErasedType: typeErasedType
                )
            }
        case let .implicitlyUnwrappedOptionalType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.wrappedType,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
        case let .memberType(type):
            result = self.type(
                type,
                typeErasedIfAnyArgumentsIn: \.genericArgumentClause,
                areContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause,
                typeErasedType: typeErasedType
            )
        case var .metatypeType(type):
            if
                let tupleType = type.baseType.as(TupleTypeSyntax.self),
                tupleType.elements.count == 1,
                let firstElement = tupleType.elements.first,
                let someOrAnyType = firstElement.type.as(SomeOrAnyTypeSyntax.self),
                someOrAnyType.someOrAnySpecifier.tokenKind == .keyword(.some)
            {
                type = type.with(\.baseType, TypeSyntax(someOrAnyType))
            }

            result = self.syntax(
                type,
                typeErasedAt: \.baseType,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
        case let .missingType(type):
            result = (newType: type, didTypeErase: false)
        case let .namedOpaqueReturnType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.type,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
        case var .optionalType(type):
            let tupleType = TupleTypeSyntax(elements: [
                TupleTypeElementSyntax(type: type.wrappedType),
            ])

            type = type.with(\.wrappedType, TypeSyntax(tupleType))

            result = self.syntax(
                type,
                typeErasedAt: \.wrappedType,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
        case let .packElementType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.pack,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
        case let .packExpansionType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.repetitionPattern,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
        case var .someOrAnyType(type):
            let anySpecifier = TokenSyntax(
                .keyword(.any),
                trailingTrivia: .space,
                presence: .present
            )

            let constraint: any TypeSyntaxProtocol = if
                let compositionType = type.constraint.as(CompositionTypeSyntax.self),
                compositionType.elements.count > 1
            {
                TupleTypeSyntax(elements: [
                    TupleTypeElementSyntax(type: compositionType),
                ])
            } else {
                type.constraint
            }

            type = type
                .with(\.someOrAnySpecifier, anySpecifier)
                .with(\.constraint, TypeSyntax(constraint))
            result = self.syntax(
                type,
                typeErasedAt: \.constraint,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
        case let .suppressedType(type):
            result = self.syntax(
                type,
                typeErasedAt: \.type,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
        case let .tupleType(type):
            result = self.syntax(
                type,
                withElementsInCollectionAt: \.elements,
                typeErasedAt: \.type,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
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
    ///   - genericWhereClause: The generic where clause from which to parse
    ///     conformance requirements for the provided `genericParameters`.
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
        typeConstrainedBy genericWhereClause: GenericWhereClauseSyntax?,
        typeErasedType: TypeErasedType.Type = Any.self
    ) -> (Syntax, Bool) {
        let (type, didTypeErase) = self.type(
            syntax[keyPath: typeKeyPath],
            typeErasedIfNecessaryUsing: genericParameters,
            typeConstrainedBy: genericWhereClause,
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
    ///   - genericWhereClause: The generic where clause from which to parse
    ///     conformance requirements for the provided `genericParameters`.
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
        typeConstrainedBy genericWhereClause: GenericWhereClauseSyntax?
    ) -> (Syntax, Bool) {
        self.syntax(
            syntax,
            withElementsInCollectionAt: collectionKeyPath,
            typeErasedAt: typeKeyPath,
            ifTypeIsContainedIn: genericParameters,
            typeConstrainedBy: genericWhereClause
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
    ///   - genericWhereClause: The generic where clause from which to parse
    ///     conformance requirements for the provided `genericParameters`.
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
        typeConstrainedBy genericWhereClause: GenericWhereClauseSyntax?,
        typeErasedType: (Int) -> Any.Type
    ) -> (Syntax, Bool) {
        var newElements: [Collection.Element] = []
        var didTypeErase = false

        for (index, element) in syntax[keyPath: collectionKeyPath].enumerated() {
            let (newElement, didTypeEraseElement) = self.syntax(
                element,
                typeErasedAt: typeKeyPath,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause,
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
    ///   - genericWhereClause: The generic where clause from which to parse
    ///     conformance requirements for the provided `genericParameters`.
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
        typeConstrainedBy genericWhereClause: GenericWhereClauseSyntax?,
        typeErasedType: TypeErasedType.Type
    ) -> (
        newType: any TypeSyntaxProtocol,
        didTypeErase: Bool
    ) {
        guard
            let genericArgumentClause = type[keyPath: genericArgumentClauseKeyPath]
        else {
            return (newType: type, didTypeErase: false)
        }

        switch TypeSyntax(type).as(TypeSyntaxEnum.self) {
        case let .identifierType(type) where self.isIdentifierType(
            type,
            named: "Optional", "Array"
        ):
            let (newGenericArgumentClause, didTypeErase) = self.syntax(
                genericArgumentClause,
                withElementsInCollectionAt: \.arguments,
                typeErasedAt: \.argument,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
            let newType = type.with(\.genericArgumentClause, newGenericArgumentClause)

            return (newType, didTypeErase)
        case let .identifierType(type) where self.isIdentifierType(
            type,
            named: "Set", "Dictionary"
        ):
            let (newGenericArgumentClause, didTypeErase) = self.syntax(
                genericArgumentClause,
                withElementsInCollectionAt: \.arguments,
                typeErasedAt: \.argument,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            ) { index in
                index == .zero ? AnyHashable.self : Any.self
            }
            let newType = type.with(\.genericArgumentClause, newGenericArgumentClause)

            return (newType, didTypeErase)
        case let .memberType(type) where self.isMemberType(
            type,
            named: "Optional", "Array",
            withBaseTypeNamed: "Swift"
        ):
            let (newGenericArgumentClause, didTypeErase) = self.syntax(
                genericArgumentClause,
                withElementsInCollectionAt: \.arguments,
                typeErasedAt: \.argument,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
            )
            let newType = type.with(\.genericArgumentClause, newGenericArgumentClause)

            return (newType, didTypeErase)
        case let .memberType(type) where self.isMemberType(
            type,
            named: "Set", "Dictionary",
            withBaseTypeNamed: "Swift"
        ):
            let (newGenericArgumentClause, didTypeErase) = self.syntax(
                genericArgumentClause,
                withElementsInCollectionAt: \.arguments,
                typeErasedAt: \.argument,
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
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
                ifTypeIsContainedIn: genericParameters,
                typeConstrainedBy: genericWhereClause
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
    private static func isIdentifierType(
        _ type: IdentifierTypeSyntax,
        named names: String...
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
    private static func isMemberType(
        _ type: MemberTypeSyntax,
        named names: String...,
        withBaseTypeNamed baseTypeName: String
    ) -> Bool {
        guard let baseType = type.baseType.as(IdentifierTypeSyntax.self) else {
            return false
        }

        return baseType.name.tokenKind == .identifier(baseTypeName)
            && names.contains { type.name.tokenKind == .identifier($0) }
    }

    /// Returns an inherited type for the provided `genericParameter`, composed
    /// using the `genericParameter`'s inherited type and any conformance
    /// requirements for that `genericParameter` contained in the provided
    /// `genericWhereClause`.
    ///
    /// - Parameters:
    ///   - genericParameter: The generic parameter for which to compose the
    ///     inherited type.
    ///   - genericWhereClause: The generic where clause from which to parse
    ///     conformance requirements for the provided `genericParameter`.
    /// - Returns: An inherited type for the provided `genericParameter`,
    ///   composed using the `genericParameter`'s inherited type and any
    ///   conformance requirements for that `genericParameter` contained in the
    ///   provided `genericWhereClause`.
    private static func inheritedType(
        for genericParameter: GenericParameterSyntax,
        typeConstrainedBy genericWhereClause: GenericWhereClauseSyntax?
    ) -> (any TypeSyntaxProtocol)? {
        let genericParameterInheritedType = genericParameter.inheritedType?.trimmed
        let genericWhereClauseInheritedTypes: [TypeSyntax]? =
            genericWhereClause?.requirements.compactMap { requirement in
                guard
                    case let .conformanceRequirement(requirement) = requirement.requirement,
                    let leftIdentifierType = requirement.leftType.as(
                        IdentifierTypeSyntax.self
                    ),
                    leftIdentifierType.name.tokenKind == genericParameter.name.tokenKind
                else {
                    return nil
                }

                return requirement.rightType
            }

        let inheritedType: (any TypeSyntaxProtocol)?

        if
            let genericWhereClauseInheritedTypes,
            !genericWhereClauseInheritedTypes.isEmpty
        {
            var inheritedTypeElements: [CompositionTypeElementSyntax] = []

            if let genericParameterInheritedType {
                inheritedTypeElements.append(
                    CompositionTypeElementSyntax(
                        type: genericParameterInheritedType.with(
                            \.trailingTrivia,
                            .space
                        ),
                        ampersand: .prefixAmpersandToken(),
                        trailingTrivia: .space
                    )
                )
            }

            for (index, type) in genericWhereClauseInheritedTypes.enumerated() {
                let isLastElement = index == genericWhereClauseInheritedTypes.count - 1
                let type = isLastElement
                    ? type.trimmed
                    : type.with(\.trailingTrivia, .space)

                inheritedTypeElements.append(
                    CompositionTypeElementSyntax(
                        type: type,
                        ampersand: isLastElement ? nil : .prefixAmpersandToken(),
                        trailingTrivia: isLastElement ? nil : .space
                    )
                )
            }

            inheritedType = CompositionTypeSyntax(
                elements: CompositionTypeElementListSyntax(inheritedTypeElements)
            )
        } else {
            inheritedType = genericParameterInheritedType
        }

        guard
            let inheritedCompositionType = inheritedType?.as(
                CompositionTypeSyntax.self
            ),
            inheritedCompositionType.elements.count > 1
        else {
            return inheritedType
        }

        return TupleTypeSyntax(elements: [
            TupleTypeElementSyntax(type: inheritedCompositionType),
        ])
    }
}
