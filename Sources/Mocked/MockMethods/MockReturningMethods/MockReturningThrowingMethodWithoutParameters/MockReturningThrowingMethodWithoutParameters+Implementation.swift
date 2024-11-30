//
//  MockReturningThrowingMethodWithoutParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockReturningThrowingMethodWithoutParameters {

    /// An implementation for a mock's returning, throwing method without
    /// parameters.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Triggers a test failure when invoked.
        case unimplemented

        /// Returns a value when invoked.
        case uncheckedReturns(() -> ReturnValue)

        /// Throws an error when invoked.
        case uncheckedThrows(() -> any Error)

        // MARK: Constructors

        /// Returns a value when invoked.
        public static func uncheckedReturns(_ value: ReturnValue) -> Self {
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
        /// ``uncheckedReturns(_:)-swift.type.method``, or throwing an error if the
        /// implementation is ``uncheckedThrows(_:)-swift.enum.case`` or
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
        ) throws -> ReturnValue {
            switch self {
            case .unimplemented:
                XCTestDynamicOverlay.unimplemented("\(description)")
            case let .uncheckedReturns(value):
                value()
            case let .uncheckedThrows(error):
                throw error()
            }
        }
    }
}

// MARK: - Sendable

extension MockReturningThrowingMethodWithoutParameters.Implementation
    where ReturnValue: Sendable
{

    // MARK: Constructors

    /// Returns a value when invoked.
    public static func returns(
        _ value: @Sendable @escaping () -> ReturnValue
    ) -> Self {
        .uncheckedReturns(value)
    }

    /// Returns a value when invoked.
    public static func returns(_ value: ReturnValue) -> Self {
        .uncheckedReturns { value }
    }

    /// Throws an error when invoked.
    public static func `throws`(
        _ error: @Sendable @escaping () -> any Error
    ) -> Self {
        .uncheckedThrows(error)
    }

    /// Throws an error when invoked.
    public static func `throws`(_ error: any Error) -> Self {
        .uncheckedThrows { error }
    }
}
