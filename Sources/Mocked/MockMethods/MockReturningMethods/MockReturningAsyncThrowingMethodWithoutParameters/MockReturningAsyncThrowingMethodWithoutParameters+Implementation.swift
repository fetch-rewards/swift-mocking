//
//  MockReturningAsyncThrowingMethodWithoutParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockReturningAsyncThrowingMethodWithoutParameters {

    /// An implementation for a mock's returning, async, throwing method without
    /// parameters.
    public enum Implementation {

        // MARK: Cases

        /// Triggers a test failure when invoked.
        case unimplemented

        /// Returns a value when invoked.
        case returns(() async -> ReturnValue)

        /// Throws an error when invoked.
        case `throws`(() async -> Error)

        // MARK: Constructors

        /// Returns a value when invoked.
        public static func returns(_ value: ReturnValue) -> Self {
            .returns { value }
        }

        /// Throws an error when invoked.
        public static func `throws`(_ error: Error) -> Self {
            .throws { error }
        }

        // MARK: Call As Function

        /// Invokes the implementation, triggering a test failure if the
        /// implementation is ``unimplemented``, returning a value if the
        /// implementation is ``returns(_:)-swift.enum.case`` or
        /// ``returns(_:)-swift.type.method``, or throwing an error if the
        /// implementation is ``throws(_:)-swift.enum.case`` or
        /// ``throws(_:)-swift.type.method``.
        ///
        /// - Parameter description: The implementation's description.
        /// - Throws: An error, if the implementation is 
        ///   ``throws(_:)-swift.enum.case`` or
        ///   ``throws(_:)-swift.type.method``.
        /// - Returns: A value, if the implementation is
        ///   ``returns(_:)-swift.enum.case`` or
        ///   ``returns(_:)-swift.type.method``.
        func callAsFunction(
            description: MockImplementationDescription
        ) async throws -> ReturnValue {
            switch self {
            case .unimplemented:
                XCTestDynamicOverlay.unimplemented("\(description)")
            case let .returns(value):
                await value()
            case let .throws(error):
                throw await error()
            }
        }
    }
}
