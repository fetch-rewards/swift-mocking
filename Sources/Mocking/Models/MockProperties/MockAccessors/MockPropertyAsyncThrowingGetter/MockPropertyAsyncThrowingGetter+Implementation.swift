//
//  MockPropertyAsyncThrowingGetter+Implementation.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation

extension MockPropertyAsyncThrowingGetter {

    /// An implementation for an async, throwing mock property getter.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Triggers a fatal error when invoked.
        case unimplemented

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        case uncheckedInvokes(_ closure: () async throws -> Value)

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
            _ closure: @Sendable @escaping () async throws -> Value
        ) -> Self where Value: Sendable {
            .uncheckedInvokes(closure)
        }

        /// Throws the provided error when invoked.
        ///
        /// - Parameter error: The error to throw.
        public static func `throws`(_ error: any Error) -> Self {
            .uncheckedInvokes { throw error }
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
        /// - Throws: An error, if the implementation throws an error.
        /// - Returns: A value, if the implementation returns a value.
        func callAsFunction() async throws -> Value? {
            switch self {
            case .unimplemented:
                nil
            case let .uncheckedInvokes(closure):
                try await closure()
            }
        }
    }
}
