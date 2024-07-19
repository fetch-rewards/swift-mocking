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
    public enum Implementation {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes a closure when invoked.
        case invokes(() async -> Void)

        /// Throws an error when invoked.
        case `throws`(() async -> any Error)

        // MARK: Constructors

        /// Throws an error when invoked.
        public static func `throws`(_ error: any Error) -> Self {
            .throws { error }
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
            case let .invokes(closure):
                await closure()
            case let .throws(error):
                throw await error()
            }
        }
    }
}
