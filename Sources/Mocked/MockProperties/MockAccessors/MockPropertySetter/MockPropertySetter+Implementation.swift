//
//  MockPropertySetter+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockPropertySetter {

    /// An implementation for a mock's property setter.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes a closure when invoked.
        case uncheckedInvokes((Value) -> Void)

        // MARK: Call As Function

        /// Invokes the implementation, doing nothing if the implementation is
        /// ``unimplemented`` or invoking a closure if the implementation is
        /// ``uncheckedInvokes(_:)``.
        ///
        /// - Parameter value: The value with which to invoke the
        ///   implementation.
        func callAsFunction(value: Value) {
            switch self {
            case .unimplemented:
                return
            case let .uncheckedInvokes(closure):
                closure(value)
            }
        }
    }
}

// MARK: - Sendable

extension MockPropertySetter.Implementation
where Value: Sendable {

    // MARK: Constructors

    /// Invokes a closure when invoked.
    public static func invokes(
        _ closure: @Sendable @escaping (Value) -> Void
    ) -> Self {
        .uncheckedInvokes(closure)
    }
}
