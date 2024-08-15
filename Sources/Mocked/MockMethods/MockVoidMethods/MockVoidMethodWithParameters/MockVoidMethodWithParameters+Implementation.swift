//
//  MockVoidMethodWithParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockVoidMethodWithParameters {

    /// An implementation for a mock's void method with parameters.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes a closure when invoked.
        case uncheckedInvokes((Arguments) -> Void)

        // MARK: Call As Function

        /// Invokes the implementation, doing nothing if the implementation is
        /// ``unimplemented`` or invoking a closure if the implementation is
        /// ``invokes(_:)``.
        ///
        /// - Parameter arguments: The arguments with which to invoke the
        ///   implementation.
        func callAsFunction(arguments: Arguments) {
            switch self {
            case .unimplemented:
                return
            case let .uncheckedInvokes(closure):
                closure(arguments)
            }
        }
    }
}

// MARK: - Sendable

extension MockVoidMethodWithParameters.Implementation
where Arguments: Sendable {

    // MARK: Constructors

    /// Invokes a closure when invoked.
    public static func invokes(
        _ closure: @Sendable @escaping (Arguments) -> Void
    ) -> Self {
        .uncheckedInvokes(closure)
    }
}
