//
//  MockPropertyAsyncThrowingGetter+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockPropertyAsyncThrowingGetter {

    /// An implementation for a mock's async, throwing property getter.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Triggers a test failure when invoked.
        case unimplemented

        /// Returns a value when invoked.
        case uncheckedReturns(() async -> Value)

        /// Throws an error when invoked.
        case uncheckedThrows(() async -> any Error)

        // MARK: Constructors

        /// Returns a value when invoked.
        public static func uncheckedReturns(_ value: Value) -> Self {
            .uncheckedReturns { value }
        }

        /// Throws an error when invoked.
        public static func uncheckedThrows(_ error: any Error) -> Self {
            .uncheckedThrows { error }
        }

        // MARK: Call As Function

        /// Invokes the implementation, triggering a test failure if the
        /// implementation is ``unimplemented``, returning a value if the
        /// implementation is ``uncheckedReturns(_:)-swift.enum.case`` or
        /// ``uncheckedReturns(_:)-swift.type.method``, or throwing an error if
        /// the implementation is ``uncheckedThrows(_:)-swift.enum.case`` or
        /// ``uncheckedThrows(_:)-swift.type.method``.
        ///
        /// - Parameter description: The implementation's description.
        /// - Throws: An error, if the implementation is
        ///   ``uncheckedThrows(_:)-swift.enum.case`` or
        ///   ``uncheckedThrows(_:)-swift.type.method``.
        /// - Returns: A value, if the implementation is
        ///   ``uncheckedReturns(_:)-swift.enum.case`` or
        ///   ``uncheckedReturns(_:)-swift.type.method``.
        func callAsFunction(
            description: MockImplementationDescription
        ) async throws -> Value {
            switch self {
            case .unimplemented:
                XCTestDynamicOverlay.unimplemented("\(description)")
            case let .uncheckedReturns(value):
                await value()
            case let .uncheckedThrows(error):
                throw await error()
            }
        }
    }
}

// MARK: - Sendable

extension MockPropertyAsyncThrowingGetter.Implementation
    where Value: Sendable
{

    // MARK: Constructors

    /// Returns a value when invoked.
    public static func returns(
        _ value: @Sendable @escaping () async -> Value
    ) -> Self {
        .uncheckedReturns(value)
    }

    /// Returns a value when invoked.
    public static func returns(_ value: Value) -> Self {
        .uncheckedReturns { value }
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
