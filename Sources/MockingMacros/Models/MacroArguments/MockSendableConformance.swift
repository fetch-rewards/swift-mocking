//
//  MockSendableConformance.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax

/// A `Sendable` conformance that can be applied to a mock declaration.
enum MockSendableConformance: String, MacroArgumentValue {

    /// The mock conforms to the protocol it is mocking, resulting in
    /// checked `Sendable` conformance if the protocol inherits from
    /// `Sendable`.
    case checked

    /// The mock conforms to `@unchecked Sendable`.
    case unchecked

    /// Creates a sendable conformance from the provided `argument`.
    ///
    /// - Parameter argument: The argument syntax from which to parse a
    ///   `Sendable` conformance.
    init?(argument: LabeledExprSyntax) {
        guard
            let memberAccessExpression = argument.expression.as(
                MemberAccessExprSyntax.self
            ),
            let identifier = memberAccessExpression.declName.baseName.identifier
        else {
            return nil
        }

        self.init(rawValue: identifier.name)
    }
}
