//
//  MockedPropertyType+ThrowsSpecifier.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax

extension MockedPropertyType {

    /// The `throws` specifier to apply to a mocked property's accessor.
    enum ThrowsSpecifier: String, CaseIterable {

        // MARK: Cases

        /// A `throws` specifier.
        case `throws`

        // MARK: Initializers

        /// Creates a `throws` specifier from the provided `argument`.
        ///
        /// - Parameter argument: The argument syntax from which to parse a
        ///   ``ThrowsSpecifier``.
        /// - Throws: An error if a valid ``ThrowsSpecifier`` cannot be parsed
        ///   from the provided `argument`.
        init(argument: LabeledExprSyntax) throws {
            guard
                let memberAccessExpression = argument.expression.as(
                    MemberAccessExprSyntax.self
                ),
                let throwsSpecifier = Self.allCases.first(where: { throwsSpecifier in
                    let declName = memberAccessExpression.declName

                    return declName.baseName.tokenKind == .identifier(
                        throwsSpecifier.rawValue
                    )
                })
            else {
                throw ParsingError.unableToParseAsyncEffectSpecifier
            }

            self = throwsSpecifier
        }
    }
}
