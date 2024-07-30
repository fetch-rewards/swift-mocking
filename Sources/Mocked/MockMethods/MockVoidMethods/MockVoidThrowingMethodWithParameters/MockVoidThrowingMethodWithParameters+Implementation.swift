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
    public enum Implementation {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes a closure when invoked.
        case invokes((Arguments) -> Void)

        /// Throws an error when invoked.
        case `throws`((Arguments) -> any Error)

        // MARK: Constructors

        /// Throws an error when invoked.
        public static func `throws`(_ error: any Error) -> Self {
            .throws { _ in error }
        }

        // MARK: Call As Function

        /// Invokes the implementation, doing nothing if the implementation is
        /// ``unimplemented``, invoking a closure if the implementation is
        /// ``invokes(_:)``, or throwing an error if the implementation is
        /// ``throws(_:)-swift.enum.case`` or ``throws(_:)-swift.type.method``.
        ///
        /// - Parameter arguments: The arguments with which to invoke the
        ///   implementation.
        /// - Throws: An error, if the implementation is
        ///   ``throws(_:)-swift.enum.case`` or
        ///   ``throws(_:)-swift.type.method``.
        func callAsFunction(arguments: Arguments) throws {
            switch self {
            case .unimplemented:
                return
            case let .invokes(closure):
                closure(arguments)
            case let .throws(error):
                throw error(arguments)
            }
        }
    }
}
