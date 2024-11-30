//
//  MockPropertyAsyncGetter+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockPropertyAsyncGetter {

    /// An implementation for a mock's async property getter.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Triggers a test failure when invoked.
        case unimplemented

        /// Returns a value when invoked.
        case uncheckedReturns(() async -> Value)

        // MARK: Constructors

        /// Returns a value when invoked.
        public static func uncheckedReturns(_ value: Value) -> Self {
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
        ) async -> Value {
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

extension MockPropertyAsyncGetter.Implementation
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
}
