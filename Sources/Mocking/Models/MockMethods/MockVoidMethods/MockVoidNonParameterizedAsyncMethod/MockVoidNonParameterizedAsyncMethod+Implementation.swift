//
//  MockVoidNonParameterizedAsyncMethod+Implementation.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation

extension MockVoidNonParameterizedAsyncMethod {

    /// An implementation for a void, non-parameterized, async mock method.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        case uncheckedInvokes(_ closure: () async -> Void)

        // MARK: Constructors

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        public static func invokes(
            _ closure: @Sendable @escaping () async -> Void
        ) -> Self {
            .uncheckedInvokes(closure)
        }

        // MARK: Call As Function

        /// Invokes the implementation.
        func callAsFunction() async {
            switch self {
            case .unimplemented:
                return
            case let .uncheckedInvokes(closure):
                await closure()
            }
        }
    }
}
