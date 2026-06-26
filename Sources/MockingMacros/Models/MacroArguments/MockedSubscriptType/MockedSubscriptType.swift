//
//  MockedSubscriptType.swift
//
//  Copyright © 2026 Fetch.
//

import SwiftSyntax

/// The type of subscript being mocked.
enum MockedSubscriptType: MacroArgumentValue {

    // MARK: Cases

    /// A read-only subscript.
    case readOnly

    /// A read-write subscript.
    case readWrite

    // MARK: Initializers

    /// Creates a ``MockedSubscriptType`` from the provided `argument`.
    ///
    /// - Parameter argument: The argument syntax from which to parse a
    ///   ``MockedSubscriptType``.
    /// - Throws: An error if a valid ``MockedSubscriptType`` cannot be parsed
    ///   from the provided `argument`.
    init(argument: LabeledExprSyntax) throws {
        guard
            let memberAccessExpression = argument.expression.as(
                MemberAccessExprSyntax.self
            )
        else {
            throw ParsingError.unableToParseSubscriptType
        }

        let declarationNameTokenKind = memberAccessExpression.declName.baseName.tokenKind

        if declarationNameTokenKind == .identifier("readOnly") {
            self = .readOnly
        } else if declarationNameTokenKind == .identifier("readWrite") {
            self = .readWrite
        } else {
            throw ParsingError.unableToParseSubscriptType
        }
    }
}
