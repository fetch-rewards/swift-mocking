//
//  MockReturningAsyncThrowingMethodWithParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockReturningAsyncThrowingMethodWithParameters {

    /// An implementation for a mock's returning, async, throwing method with
    /// parameters.
    public enum Implementation {

        // MARK: Cases

        /// Triggers a test failure when invoked.
        case unimplemented

        /// Returns a value when invoked.
        case returns((Arguments) async -> ReturnValue)

        /// Throws an error when invoked.
        case `throws`((Arguments) async -> any Error)

        // MARK: Constructors

        /// Returns a value when invoked.
        public static func returns(_ value: ReturnValue) -> Self {
            .returns { _ in value }
        }

        /// Throws an error when invoked.
        public static func `throws`(_ error: any Error) -> Self {
            .throws { _ in error }
        }

        // MARK: Call As Function

        /// Invokes the implementation, triggering a test failure if the
        /// implementation is ``unimplemented``, returning a value if the
        /// implementation is ``returns(_:)-swift.enum.case`` or
        /// ``returns(_:)-swift.type.method``, or throwing an error if the
        /// implementation is ``throws(_:)-swift.enum.case`` or
        /// ``throws(_:)-swift.type.method``.
        ///
        /// - Parameters:
        ///   - arguments: The arguments with which to invoke the
        ///     implementation.
        ///   - description: The implementation's description.
        /// - Throws: An error, if the implementation is
        ///   ``throws(_:)-swift.enum.case`` or
        ///   ``throws(_:)-swift.type.method``.
        /// - Returns: A value, if the implementation is
        ///   ``returns(_:)-swift.enum.case`` or
        ///   ``returns(_:)-swift.type.method``.
        func callAsFunction(
            arguments: Arguments,
            description: MockImplementationDescription
        ) async throws -> ReturnValue {
            switch self {
            case .unimplemented:
                XCTestDynamicOverlay.unimplemented("\(description)")
            case let .returns(value):
                await value(arguments)
            case let .throws(error):
                throw await error(arguments)
            }
        }
    }
}
