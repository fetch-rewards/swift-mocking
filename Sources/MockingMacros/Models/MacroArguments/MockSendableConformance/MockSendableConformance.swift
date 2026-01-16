//
//  MockSendableConformance.swift
//
//  Copyright © 2026 Fetch.
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

    /// Creates a `Sendable` conformance from the provided `argument`.
    ///
    /// - Parameter argument: The argument syntax from which to parse a
    ///   `Sendable` conformance.
    init(argument: LabeledExprSyntax) throws {
        guard
            let memberAccessExpression = argument.expression.as(
                MemberAccessExprSyntax.self
            ),
            let identifier = memberAccessExpression.declName.baseName.identifier,
            let sendableConformance = MockSendableConformance(rawValue: identifier.name)
        else {
            throw ParsingError.unableToParseSendableConformance
        }

        self = sendableConformance
    }
}
