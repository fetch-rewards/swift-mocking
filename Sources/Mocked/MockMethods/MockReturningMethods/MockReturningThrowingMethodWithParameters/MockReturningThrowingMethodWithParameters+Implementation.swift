//
//  MockReturningThrowingMethodWithParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockReturningThrowingMethodWithParameters {

    /// An implementation for a mock's returning, throwing method with
    /// parameters.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Triggers a test failure when invoked.
        case unimplemented

        /// Returns a value when invoked.
        case uncheckedReturns((Arguments) -> ReturnValue)

        /// Throws an error when invoked.
        case uncheckedThrows((Arguments) -> any Error)

        // MARK: Constructors

        /// Returns a value when invoked.
        public static func returns(_ value: ReturnValue) -> Self {
            .uncheckedReturns { _ in value }
        }

        /// Throws an error when invoked.
        public static func `throws`(_ error: any Error) -> Self {
            .uncheckedThrows { _ in error }
        }

        // MARK: Call As Function

        /// Invokes the implementation, triggering a test failure if the
        /// implementation is ``unimplemented``, returning a value if the
        /// implementation is ``uncheckedReturns(_:)-swift.enum.case`` or
        /// ``uncheckedReturns(_:)-swift.type.method``, or throwing an error if
        /// the implementation is ``uncheckedThrows(_:)-swift.enum.case`` or
        /// ``uncheckedThrows(_:)-swift.type.method``.
        ///
        /// - Parameters:
        ///   - arguments: The arguments with which to invoke the
        ///     implementation.
        ///   - description: The implementation's description.
        /// - Throws: An error, if the implementation is
        ///   ``uncheckedThrows(_:)-swift.enum.case`` or
        ///   ``uncheckedThrows(_:)-swift.type.method``.
        /// - Returns: A value, if the implementation is
        ///   ``uncheckedReturns(_:)-swift.enum.case`` or
        ///   ``uncheckedReturns(_:)-swift.type.method``.
        func callAsFunction(
            arguments: Arguments,
            description: MockImplementationDescription
        ) throws -> ReturnValue {
            switch self {
            case .unimplemented:
                XCTestDynamicOverlay.unimplemented("\(description)")
            case let .uncheckedReturns(value):
                value(arguments)
            case let .uncheckedThrows(error):
                throw error(arguments)
            }
        }
    }
}

// MARK: - Sendable

extension MockReturningThrowingMethodWithParameters.Implementation
where Arguments: Sendable, ReturnValue: Sendable {

    // MARK: Constructors

    /// Returns a value when invoked.
    public static func returns(
        _ value: @Sendable @escaping (Arguments) -> ReturnValue
    ) -> Self {
        .uncheckedReturns(value)
    }

    /// Returns a value when invoked.
    public static func returns(_ value: ReturnValue) -> Self {
        .uncheckedReturns { _ in value }
    }

    /// Throws an error when invoked.
    public static func `throws`(
        _ error: @Sendable @escaping (Arguments) -> any Error
    ) -> Self {
        .uncheckedThrows(error)
    }

    /// Throws an error when invoked.
    public static func `throws`(_ error: any Error) -> Self {
        .uncheckedThrows { _ in error }
    }
}
