//
//  MockVoidAsyncThrowingMethodWithoutParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockVoidAsyncThrowingMethodWithoutParameters {

    /// An implementation for a mock's void, async, throwing method without
    /// parameters.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes a closure when invoked.
        case uncheckedInvokes(() async -> Void)

        /// Throws an error when invoked.
        case uncheckedThrows(() async -> any Error)

        // MARK: Constructors

        /// Throws an error when invoked.
        public static func uncheckedThrows(_ error: any Error) -> Self {
            .uncheckedThrows { error }
        }

        // MARK: Call As Function

        /// Invokes the implementation, doing nothing if the implementation is
        /// ``unimplemented``, invoking a closure if the implementation is
        /// ``invokes(_:)``, or throwing an error if the implementation is
        /// ``throws(_:)-swift.enum.case`` or ``throws(_:)-swift.type.method``.
        ///
        /// - Throws: An error, if the implementation is
        ///   ``throws(_:)-swift.enum.case`` or
        ///   ``throws(_:)-swift.type.method``.
        func callAsFunction() async throws {
            switch self {
            case .unimplemented:
                return
            case let .uncheckedInvokes(closure):
                await closure()
            case let .uncheckedThrows(error):
                throw await error()
            }
        }
    }
}

// MARK: - Sendable

extension MockVoidAsyncThrowingMethodWithoutParameters.Implementation {

    // MARK: Constructors

    /// Invokes a closure when invoked.
    public static func invokes(
        _ closure: @Sendable @escaping () async -> Void
    ) -> Self {
        .uncheckedInvokes(closure)
    }

    /// Throws an error when invoked.
    public static func `throws`(
        _ error: @Sendable @escaping () async -> any Error
    ) -> Self {
        .uncheckedThrows(error)
    }

    /// Throws an error when invoked.
    public static func `throws`(_ error: any Error) -> Self {
        .uncheckedThrows { error }
    }
}
