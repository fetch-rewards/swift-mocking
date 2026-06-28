//
//  MockedSubscriptType+AsyncSpecifier.swift
//
//  Copyright © 2026 Fetch.
//

import SwiftSyntax

extension MockedSubscriptType {

    /// The `async` specifier to apply to a mocked subscript's accessor.
    enum AsyncSpecifier {

        // MARK: Cases

        /// An `async` specifier.
        case async

        // MARK: Initializers

        /// Creates an `async` specifier from the provided `argument`.
        ///
        /// - Parameter argument: The argument syntax from which to parse an
        ///   ``AsyncSpecifier``.
        /// - Throws: An error if a valid ``AsyncSpecifier`` cannot be parsed
        ///   from the provided `argument`.
        init(argument: LabeledExprSyntax) throws {
            guard
                let memberAccessExpression = argument.expression.as(
                    MemberAccessExprSyntax.self
                ),
                memberAccessExpression.declName.baseName.tokenKind == .identifier("async")
            else {
                throw ParsingError.unableToParseSubscriptType
            }

            self = .async
        }
    }
}
