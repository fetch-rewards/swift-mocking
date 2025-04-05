//
//  MockVoidNonParameterizedMethod+Implementation.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation

extension MockVoidNonParameterizedMethod {

    /// An implementation for a void, non-parameterized mock method.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        case uncheckedInvokes(_ closure: () -> Void)

        // MARK: Constructors

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        static func invokes(_ closure: @Sendable @escaping () -> Void) -> Self {
            .uncheckedInvokes(closure)
        }

        // MARK: Call As Function

        /// Invokes the implementation.
        func callAsFunction() {
            switch self {
            case .unimplemented:
                return
            case let .uncheckedInvokes(closure):
                closure()
            }
        }
    }
}
