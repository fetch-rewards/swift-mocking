//
//  MockPropertyAsyncGetter+Implementation.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation

extension MockPropertyAsyncGetter {

    /// An implementation for an async mock property getter.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Triggers a fatal error when invoked.
        case unimplemented

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        case uncheckedInvokes(_ closure: () async -> Value)

        // MARK: Constructors

        /// Returns the provided value when invoked.
        ///
        /// - Parameter value: The value to return.
        public static func uncheckedReturns(_ value: Value) -> Self {
            .uncheckedInvokes { value }
        }

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        public static func invokes(
            _ closure: @Sendable @escaping () async -> Value
        ) -> Self where Value: Sendable {
            .uncheckedInvokes(closure)
        }

        /// Returns the provided value when invoked.
        ///
        /// - Parameter value: The value to return.
        public static func returns(
            _ value: Value
        ) -> Self where Value: Sendable {
            .invokes { value }
        }

        // MARK: Call As Function

        /// Invokes the implementation.
        ///
        /// - Returns: A value, if the implementation returns a value.
        func callAsFunction() async -> Value? {
            switch self {
            case .unimplemented:
                nil
            case let .uncheckedInvokes(closure):
                await closure()
            }
        }
    }
}
