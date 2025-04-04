//
//  MockCompilationCondition.swift
//  Mocked
//
//  Created by Gray Campbell on 3/30/25.
//

import Foundation

/// A compilation condition for an `#if` compiler directive used to wrap a mock
/// declaration.
public enum MockCompilationCondition: RawRepresentable, Equatable, ExpressibleByStringLiteral {

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
    public var rawValue: String? {
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
    public init(rawValue: String?) {
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

    /// Creates a compilation condition from the provided string literal.
    ///
    /// - Parameter value: The compilation condition as a string literal.
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}
