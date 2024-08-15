//
//  MockVoidAsyncMethodWithParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockVoidAsyncMethodWithParameters {

    /// An implementation for a mock's void, async method with parameters.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes a closure when invoked.
        case uncheckedInvokes((Arguments) async -> Void)

        // MARK: Call As Function

        /// Invokes the implementation, doing nothing if the implementation is
        /// ``unimplemented`` or invoking a closure if the implementation is
        /// ``invokes(_:)``.
        ///
        /// - Parameter arguments: The arguments with which to invoke the
        ///   implementation.
        func callAsFunction(arguments: Arguments) async {
            switch self {
            case .unimplemented:
                return
            case let .uncheckedInvokes(closure):
                await closure(arguments)
            }
        }
    }
}

// MARK: - Sendable

extension MockVoidAsyncMethodWithParameters.Implementation
where Arguments: Sendable {

    // MARK: Constructors

    /// Invokes a closure when invoked.
    public static func invokes(
        _ closure: @Sendable @escaping (Arguments) async -> Void
    ) -> Self {
        .uncheckedInvokes(closure)
    }
}
