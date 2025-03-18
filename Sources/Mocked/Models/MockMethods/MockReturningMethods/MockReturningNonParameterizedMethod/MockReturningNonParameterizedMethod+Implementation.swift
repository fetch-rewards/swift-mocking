//
//  MockReturningNonParameterizedMethod+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation

extension MockReturningNonParameterizedMethod {

    /// An implementation for a returning, non-parameterized mock method.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Triggers a fatal error when invoked.
        case unimplemented

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        case uncheckedInvokes(_ closure: () -> ReturnValue)

        // MARK: Constructors

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        public static func invokes(
            _ closure: @Sendable @escaping () -> ReturnValue
        ) -> Self where ReturnValue: Sendable {
            .uncheckedInvokes(closure)
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
            .uncheckedReturns(value)
        }

        // MARK: Call As Function

        /// Invokes the implementation.
        ///
        /// - Returns: A value, if the implementation returns a value.
        func callAsFunction() -> ReturnValue? {
            switch self {
            case .unimplemented:
                nil
            case let .uncheckedInvokes(closure):
                closure()
            }
        }
    }
}
