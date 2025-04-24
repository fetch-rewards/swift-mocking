//
//  MockVoidNonParameterizedAsyncThrowingMethod+Implementation.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation

extension MockVoidNonParameterizedAsyncThrowingMethod {

    /// An implementation for a void, non-parameterized, async, throwing mock
    /// method.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        case uncheckedInvokes(_ closure: () async throws -> Void)

        // MARK: Constructors

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        public static func invokes(
            _ closure: @Sendable @escaping () async throws -> Void
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
        func callAsFunction() async throws {
            switch self {
            case .unimplemented:
                return
            case let .uncheckedInvokes(closure):
                try await closure()
            }
        }
    }
}
