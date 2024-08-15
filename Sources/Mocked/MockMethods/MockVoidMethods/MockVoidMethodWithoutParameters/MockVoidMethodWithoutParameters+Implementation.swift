//
//  MockVoidMethodWithoutParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockVoidMethodWithoutParameters {

    /// An implementation for a mock's void method without parameters.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes a closure when invoked.
        case uncheckedInvokes(() -> Void)

        // MARK: Call As Function

        /// Invokes the implementation, doing nothing if the implementation is
        /// ``unimplemented`` or invoking a closure if the implementation is
        /// ``invokes(_:)``.
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

// MARK: - Sendable

extension MockVoidMethodWithoutParameters.Implementation {

    // MARK: Constructors

    /// Invokes a closure when invoked.
    public static func invokes(
        _ closure: @Sendable @escaping () -> Void
    ) -> Self {
        .uncheckedInvokes(closure)
    }
}
