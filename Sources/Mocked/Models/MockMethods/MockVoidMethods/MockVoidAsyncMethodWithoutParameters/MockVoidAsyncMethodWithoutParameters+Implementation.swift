//
//  MockVoidAsyncMethodWithoutParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockVoidAsyncMethodWithoutParameters {

    /// An implementation for a mock's void, async method without parameters.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes a closure when invoked.
        case uncheckedInvokes(() async -> Void)

        // MARK: Call As Function

        /// Invokes the implementation, doing nothing if the implementation is
        /// ``unimplemented`` or invoking a closure if the implementation is
        /// ``uncheckedInvokes(_:)``.
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

// MARK: - Sendable

extension MockVoidAsyncMethodWithoutParameters.Implementation {

    // MARK: Constructors

    /// Invokes a closure when invoked.
    public static func invokes(
        _ closure: @Sendable @escaping () async -> Void
    ) -> Self {
        .uncheckedInvokes(closure)
    }
}
