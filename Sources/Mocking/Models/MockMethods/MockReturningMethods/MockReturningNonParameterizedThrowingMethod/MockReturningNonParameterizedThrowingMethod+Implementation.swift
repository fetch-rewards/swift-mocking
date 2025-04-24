//
//  MockReturningNonParameterizedThrowingMethod+Implementation.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation

extension MockReturningNonParameterizedThrowingMethod {

    /// An implementation for a returning, non-parameterized, throwing mock
    /// method.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Triggers a fatal error when invoked.
        case unimplemented

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        case uncheckedInvokes(_ closure: () throws -> ReturnValue)

        // MARK: Constructors

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        public static func invokes(
            _ closure: @Sendable @escaping () throws -> ReturnValue
        ) -> Self where ReturnValue: Sendable {
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
        public static func uncheckedReturns(_ value: ReturnValue) -> Self {
            .uncheckedInvokes { value }
        }

        /// Returns the provided value when invoked.
        ///
        /// - Parameter value: The value to return.
        public static func returns(
            _ value: ReturnValue
        ) -> Self where ReturnValue: Sendable {
            .uncheckedInvokes { value }
        }

        // MARK: Call As Function

        /// Invokes the implementation.
        ///
        /// - Throws: An error, if the implementation throws an error.
        /// - Returns: A value, if the implementation returns a value.
        func callAsFunction() throws -> ReturnValue? {
            switch self {
            case .unimplemented:
                nil
            case let .uncheckedInvokes(closure):
                try closure()
            }
        }
    }
}
