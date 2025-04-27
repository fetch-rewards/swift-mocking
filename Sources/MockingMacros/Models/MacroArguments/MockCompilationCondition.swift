//
//  MockCompilationCondition.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax

/// A compilation condition for an `#if` compiler directive used to wrap a mock
/// declaration.
enum MockCompilationCondition: RawRepresentable, Equatable, MacroArgument {

    // MARK: Cases

    /// The mock declaration is not wrapped in an `#if` compiler directive.
    case none

    /// The mock declaration is wrapped in an `#if DEBUG` compiler directive.
    case debug

    /// The mock declaration is wrapped in an `#if SWIFT_MOCKING_ENABLED`
    /// compiler directive.
    case swiftMockingEnabled

    /// The mock declaration is wrapped in an `#if` compiler directive with a
    /// custom condition.
    case custom(_ condition: String)

    // MARK: Properties

    /// The compilation condition as a string, or `nil` if the compilation
    /// condition is `.none`.
    var rawValue: String? {
        switch self {
        case .none:
            nil
        case .debug:
            "DEBUG"
        case .swiftMockingEnabled:
            "SWIFT_MOCKING_ENABLED"
        case let .custom(condition):
            condition
        }
    }

    // MARK: Initializers

    /// Creates a compilation condition from the provided `rawValue`.
    ///
    /// - Parameter rawValue: The compilation condition as a string.
    init(rawValue: String?) {
        switch rawValue {
        case .none:
            self = .none
        case "DEBUG":
            self = .debug
        case "SWIFT_MOCKING_ENABLED":
            self = .swiftMockingEnabled
        case let .some(rawValue):
            self = .custom(rawValue)
        }
    }

    /// Creates a compilation condition from the provided `argument`.
    ///
    /// - Parameter argument: The argument syntax from which to parse a
    ///   compilation condition.
    init?(argument: LabeledExprSyntax) {
        let (
            memberAccessExpression,
            arguments
        ): (
            MemberAccessExprSyntax?,
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
        } else if
            let stringLiteralExpression = argument.expression.as(
                StringLiteralExprSyntax.self
            )
        {
            (
                MemberAccessExprSyntax(name: .identifier("custom")),
                LabeledExprListSyntax {
                    LabeledExprSyntax(expression: stringLiteralExpression)
                }
            )
        } else {
            (nil, nil)
        }

        guard let memberAccessExpression else {
            return nil
        }

        let declarationNameTokenKind = memberAccessExpression.declName.baseName.tokenKind

        if declarationNameTokenKind == .identifier("none") {
            self = .none
        } else if declarationNameTokenKind == .identifier("debug") {
            self = .debug
        } else if declarationNameTokenKind == .identifier("swiftMockingEnabled") {
            self = .swiftMockingEnabled
        } else if
            declarationNameTokenKind == .identifier("custom"),
            let arguments,
            let firstArgument = arguments.first,
            let firstArgumentExpression = firstArgument.expression.as(
                StringLiteralExprSyntax.self
            ),
            let condition = firstArgumentExpression.representedLiteralValue
        {
            self = .custom(condition)
        } else {
            return nil
        }
    }
}
