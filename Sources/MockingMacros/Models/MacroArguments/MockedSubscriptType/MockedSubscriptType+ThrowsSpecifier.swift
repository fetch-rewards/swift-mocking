//
//  MockedSubscriptType+ThrowsSpecifier.swift
//
//  Copyright © 2026 Fetch.
//

import SwiftSyntax

extension MockedSubscriptType {

    /// The `throws` specifier to apply to a mocked subscript's accessor.
    enum ThrowsSpecifier {

        // MARK: Cases

        /// A `throws` specifier.
        // swiftformat:disable:next redundantBackticks
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
                memberAccessExpression.declName.baseName.tokenKind == .identifier("throws")
            else {
                throw ParsingError.unableToParseThrowsEffectSpecifier
            }

            self = .throws
        }
    }
}
