//
//  MockVoidThrowingMethodWithParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockVoidThrowingMethodWithParameters {

    /// An implementation for a mock's void, throwing method with parameters.
    public enum Implementation: @unchecked Sendable {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes a closure when invoked.
        case uncheckedInvokes((Arguments) -> Void)

        /// Throws an error when invoked.
        case uncheckedThrows((Arguments) -> any Error)

        // MARK: Constructors

        /// Throws an error when invoked.
        public static func uncheckedThrows(_ error: any Error) -> Self {
            .uncheckedThrows { _ in error }
        }

        // MARK: Call As Function

        /// Invokes the implementation, doing nothing if the implementation is
        /// ``unimplemented``, invoking a closure if the implementation is
        /// ``uncheckedInvokes(_:)``, or throwing an error if the implementation
        /// is ``uncheckedThrows(_:)-swift.enum.case`` or
        /// ``uncheckedThrows(_:)-swift.type.method``.
        ///
        /// - Parameter arguments: The arguments with which to invoke the
        ///   implementation.
        /// - Throws: An error, if the implementation is
        ///   ``uncheckedThrows(_:)-swift.enum.case`` or
        ///   ``uncheckedThrows(_:)-swift.type.method``.
        func callAsFunction(arguments: Arguments) throws {
            switch self {
            case .unimplemented:
                return
            case let .uncheckedInvokes(closure):
                closure(arguments)
            case let .uncheckedThrows(error):
                throw error(arguments)
            }
        }
    }
}

// MARK: - Sendable

extension MockVoidThrowingMethodWithParameters.Implementation
where Arguments: Sendable {

    // MARK: Constructors

    /// Invokes a closure when invoked.
    public static func invokes(
        _ closure: @Sendable @escaping (Arguments) -> Void
    ) -> Self {
        .uncheckedInvokes(closure)
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
