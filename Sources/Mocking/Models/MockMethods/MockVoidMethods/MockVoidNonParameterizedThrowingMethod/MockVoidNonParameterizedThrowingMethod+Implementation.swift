//
//  MockVoidNonParameterizedThrowingMethod+Implementation.swift
//  Mocking
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation

extension MockVoidNonParameterizedThrowingMethod {

    /// An implementation for a void, non-parameterized, throwing mock method.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        case uncheckedInvokes(_ closure: () throws -> Void)

        // MARK: Constructors

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        public static func invokes(
            _ closure: @Sendable @escaping () throws -> Void
        ) -> Self {
            .uncheckedInvokes(closure)
        }

        /// Throws the provided error when invoked.
        ///
        /// - Parameter error: The error to throw.
        public static func `throws`(_ error: any Error) -> Self {
            .uncheckedInvokes { throw error }
        }

        // MARK: Call As Function

        /// Invokes the implementation.
        ///
        /// - Throws: An error, if the implementation throws an error.
        func callAsFunction() throws {
            switch self {
            case .unimplemented:
                return
            case let .uncheckedInvokes(closure):
                try closure()
            }
        }
    }
}
