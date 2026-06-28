//
//  MockSubscriptThrowingGetter+Implementation.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation

extension MockSubscriptThrowingGetter {

    /// An implementation for a throwing mock subscript getter.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Triggers a fatal error when invoked.
        case unimplemented

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        case uncheckedInvokes(_ closure: (Arguments) throws -> Value)

        // MARK: Constructors

        /// Returns the provided value when invoked.
        ///
        /// - Parameter value: The value to return.
        public static func uncheckedReturns(_ value: Value) -> Self {
            .uncheckedInvokes { _ in value }
        }

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        public static func invokes(
            _ closure: @Sendable @escaping (Arguments) throws -> Value
        ) -> Self where Arguments: Sendable, Value: Sendable {
            .uncheckedInvokes(closure)
        }

        /// Throws the provided error when invoked.
        ///
        /// - Parameter error: The error to throw.
        public static func `throws`(_ error: any Error) -> Self {
            .uncheckedInvokes { _ in throw error }
        }

        /// Returns the provided value when invoked.
        ///
        /// - Parameter value: The value to return.
        public static func returns(
            _ value: Value
        ) -> Self where Arguments: Sendable, Value: Sendable {
            .invokes { _ in value }
        }

        // MARK: Call As Function

        /// Invokes the implementation.
        ///
        /// - Parameter arguments: The arguments with which to invoke the implementation.
        /// - Throws: An error, if the implementation throws an error.
        /// - Returns: A value, if the implementation returns a value.
        func callAsFunction(_ arguments: Arguments) throws -> Value? {
            switch self {
            case .unimplemented:
                nil
            case let .uncheckedInvokes(closure):
                try closure(arguments)
            }
        }
    }
}
