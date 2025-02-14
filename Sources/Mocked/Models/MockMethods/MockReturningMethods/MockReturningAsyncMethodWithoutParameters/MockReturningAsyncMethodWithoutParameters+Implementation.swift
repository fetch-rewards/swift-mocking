//
//  MockReturningAsyncMethodWithoutParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockReturningAsyncMethodWithoutParameters {

    /// An implementation for a mock's returning, async method without
    /// parameters.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Triggers a test failure when invoked.
        case unimplemented

        /// Returns a value when invoked.
        case uncheckedReturns(() async -> ReturnValue)

        // MARK: Constructors

        /// Returns a value when invoked.
        public static func uncheckedReturns(_ value: ReturnValue) -> Self {
            .uncheckedReturns { value }
        }

        // MARK: Call As Function

        /// Invokes the implementation, triggering a test failure if the
        /// implementation is ``unimplemented`` or returning a value if the
        /// implementation is ``uncheckedReturns(_:)-swift.enum.case`` or
        /// ``uncheckedReturns(_:)-swift.type.method``.
        ///
        /// - Parameter description: The implementation's description.
        /// - Returns: A value, if the implementation is
        ///   ``uncheckedReturns(_:)-swift.enum.case`` or
        ///   ``uncheckedReturns(_:)-swift.type.method``.
        func callAsFunction(
            description: MockImplementationDescription
        ) async -> ReturnValue {
            switch self {
            case .unimplemented:
                XCTestDynamicOverlay.unimplemented("\(description)")
            case let .uncheckedReturns(value):
                await value()
            }
        }
    }
}

// MARK: - Sendable

extension MockReturningAsyncMethodWithoutParameters.Implementation
    where ReturnValue: Sendable
{

    // MARK: Constructors

    /// Returns a value when invoked.
    public static func returns(
        _ value: @Sendable @escaping () async -> ReturnValue
    ) -> Self {
        .uncheckedReturns(value)
    }

    /// Returns a value when invoked.
    public static func returns(_ value: ReturnValue) -> Self {
        .uncheckedReturns { value }
    }
}
