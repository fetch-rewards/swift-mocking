//
//  MockReturningMethodWithParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockReturningMethodWithParameters {

    /// An implementation for a mock's returning method with parameters.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Triggers a test failure when invoked.
        case unimplemented

        /// Returns a value when invoked.
        case uncheckedReturns((Arguments) -> ReturnValue)

        // MARK: Constructors

        /// Returns a value when invoked.
        public static func uncheckedReturns(_ value: ReturnValue) -> Self {
            .uncheckedReturns { _ in value }
        }

        // MARK: Call As Function

        /// Invokes the implementation, triggering a test failure if the
        /// implementation is ``unimplemented`` or returning a value if the
        /// implementation is ``uncheckedReturns(_:)-swift.enum.case`` or
        /// ``uncheckedReturns(_:)-swift.type.method``.
        ///
        /// - Parameters:
        ///   - arguments: The arguments with which to invoke the
        ///     implementation.
        ///   - description: The implementation's description.
        /// - Returns: A value if the implementation is
        ///   ``uncheckedReturns(_:)-swift.enum.case`` or
        ///   ``uncheckedReturns(_:)-swift.type.method``.
        func callAsFunction(
            arguments: Arguments,
            description: MockImplementationDescription
        ) -> ReturnValue {
            switch self {
            case .unimplemented:
                XCTestDynamicOverlay.unimplemented("\(description)")
            case let .uncheckedReturns(value):
                value(arguments)
            }
        }
    }
}

// MARK: - Sendable

extension MockReturningMethodWithParameters.Implementation
    where Arguments: Sendable, ReturnValue: Sendable
{

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
}
