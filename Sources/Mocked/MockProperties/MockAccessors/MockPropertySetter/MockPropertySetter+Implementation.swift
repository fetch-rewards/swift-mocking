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
    public enum Implementation {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes a closure when invoked.
        case invokes((Value) -> Void)

        // MARK: Call As Function

        /// Invokes the implementation, doing nothing if the implementation is
        /// ``unimplemented`` or invoking a closure if the implementation is
        /// ``invokes(_:)``.
        ///
        /// - Parameter value: The value with which to invoke the
        ///   implementation.
        func callAsFunction(value: Value) {
            switch self {
            case .unimplemented:
                return
            case let .invokes(closure):
                closure(value)
            }
        }
    }
}
