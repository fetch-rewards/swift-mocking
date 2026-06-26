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
        case uncheckedInvokes(_ closure: (Key, Value) -> Void)

        // MARK: Constructors

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        public static func invokes(
            _ closure: @Sendable @escaping (Key, Value) -> Void
        ) -> Self where Key: Sendable, Value: Sendable {
            .uncheckedInvokes(closure)
        }

        // MARK: Call As Function

        /// Invokes the implementation.
        ///
        /// - Parameters:
        ///   - key: The key with which to invoke the implementation.
        ///   - newValue: The new value with which to invoke the implementation.
        func callAsFunction(_ key: Key, _ newValue: Value) {
            switch self {
            case .unimplemented:
                return
            case let .uncheckedInvokes(closure):
                closure(key, newValue)
            }
        }
    }
}
