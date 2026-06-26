//
//  MockSubscriptSetter+Implementation.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation

extension MockSubscriptSetter {

    /// An implementation for a mock subscript setter.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        case uncheckedInvokes(_ closure: (Arguments, Value) -> Void)

        // MARK: Constructors

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        public static func invokes(
            _ closure: @Sendable @escaping (Arguments, Value) -> Void
        ) -> Self where Arguments: Sendable, Value: Sendable {
            .uncheckedInvokes(closure)
        }

        // MARK: Call As Function

        /// Invokes the implementation.
        ///
        /// - Parameters:
        ///   - arguments: The arguments with which to invoke the implementation.
        ///   - newValue: The new value with which to invoke the implementation.
        func callAsFunction(_ arguments: Arguments, _ newValue: Value) {
            switch self {
            case .unimplemented:
                return
            case let .uncheckedInvokes(closure):
                closure(arguments, newValue)
            }
        }
    }
}
