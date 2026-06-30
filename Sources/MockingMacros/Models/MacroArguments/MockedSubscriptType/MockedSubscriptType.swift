//
//  MockedSubscriptType.swift
//
//  Copyright © 2026 Fetch.
//

import SwiftSyntax

/// The type of subscript being mocked.
enum MockedSubscriptType: MacroArgumentValue, Equatable {

    // MARK: Cases

    /// A read-only subscript.
    ///
    /// - Parameters:
    ///   - asyncSpecifier: The getter's `async` specifier.
    ///   - throwsSpecifier: The getter's `throws` specifier.
    case readOnly(AsyncSpecifier?, ThrowsSpecifier?)

    /// A read-write subscript.
    case readWrite

    // MARK: Properties

    /// A read-only subscript without any effect specifiers.
    static var readOnly: MockedSubscriptType {
        .readOnly(nil, nil)
    }

    /// The getter's `async` specifier, if there is one.
    var getterAsyncSpecifier: AsyncSpecifier? {
        switch self {
        case let .readOnly(asyncSpecifier, _):
            asyncSpecifier
        case .readWrite:
            nil
        }
    }

    /// The getter's `throws` specifier, if there is one.
    var getterThrowsSpecifier: ThrowsSpecifier? {
        switch self {
        case let .readOnly(_, throwsSpecifier):
            throwsSpecifier
        case .readWrite:
            nil
        }
    }

    // MARK: Initializers

    /// Creates a ``MockedSubscriptType`` from the provided `argument`.
    ///
    /// - Parameter argument: The argument syntax from which to parse a
    ///   ``MockedSubscriptType``.
    /// - Throws: An error if a valid ``MockedSubscriptType`` cannot be parsed
    ///   from the provided `argument`.
    init(argument: LabeledExprSyntax) throws {
        let (
            memberAccessExpression,
            arguments
        ): (
            MemberAccessExprSyntax,
            LabeledExprListSyntax?
        ) = if
            let functionCallExpression = argument.expression.as(
                FunctionCallExprSyntax.self
            ),
            let memberAccessExpression = functionCallExpression.calledExpression.as(
                MemberAccessExprSyntax.self
            )
        {
            (memberAccessExpression, functionCallExpression.arguments)
        } else if
            let memberAccessExpression = argument.expression.as(
                MemberAccessExprSyntax.self
            )
        {
            (memberAccessExpression, nil)
        } else {
            throw ParsingError.unableToParseSubscriptType
        }

        let declarationNameTokenKind = memberAccessExpression.declName.baseName.tokenKind

        if declarationNameTokenKind == .identifier("readOnly") {
            var asyncSpecifier: AsyncSpecifier?
            var throwsSpecifier: ThrowsSpecifier?

            if let arguments {
                for argument in arguments {
                    if asyncSpecifier == nil {
                        asyncSpecifier = try? AsyncSpecifier(argument: argument)
                    }

                    if throwsSpecifier == nil {
                        throwsSpecifier = try? ThrowsSpecifier(argument: argument)
                    }
                }
            }

            self = .readOnly(asyncSpecifier, throwsSpecifier)
        } else if declarationNameTokenKind == .identifier("readWrite") {
            self = .readWrite
        } else {
            throw ParsingError.unableToParseSubscriptType
        }
    }
}
