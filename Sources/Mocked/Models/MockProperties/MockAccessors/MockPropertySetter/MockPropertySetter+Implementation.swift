//
//  MockPropertySetter+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation

extension MockPropertySetter {

    /// An implementation for a mock property setter.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        case uncheckedInvokes(_ closure: (Value) -> Void)

        // MARK: Constructors

        /// Invokes the provided closure when invoked.
        ///
        /// - Parameter closure: The closure to invoke.
        public static func invokes(
            _ closure: @Sendable @escaping (Value) -> Void
        ) -> Self where Value: Sendable {
            .uncheckedInvokes(closure)
        }

        // MARK: Call As Function

        /// Invokes the implementation.
        ///
        /// - Parameter value: The value with which to invoke the
        ///   implementation.
        func callAsFunction(_ value: Value) {
            switch self {
            case .unimplemented:
                return
            case let .uncheckedInvokes(closure):
                closure(value)
            }
        }
    }
}
