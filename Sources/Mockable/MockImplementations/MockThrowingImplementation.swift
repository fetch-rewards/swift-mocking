//
//  MockThrowingImplementation.swift
//  Mockable
//
//  Created by Cole Campbell on 11/11/23.
//

import Foundation
import XCTestDynamicOverlay

/// A mock's throwing implementation.
public enum MockThrowingImplementation<Value> {

    // MARK: Cases

    /// Triggers a test failure when invoked.
    case unimplemented

    /// Returns a value when invoked.
    case returns(Value)

    /// Throws an error when invoked.
    case `throws`(Error)

    // MARK: Call As Function

    /// Invokes the implementation, triggering a test failure if the
    /// implementation is ``MockThrowingImplementation/unimplemented``,
    /// returning a value if the implementation is
    /// ``MockThrowingImplementation/returns(_:)``, or throwing an error if the
    /// implementation is ``MockThrowingImplementation/throws(_:)``.
    ///
    /// - Parameter description: The implementation's description.
    /// - Throws: An error if the implementation is
    ///   ``MockThrowingImplementation/throws(_:)``.
    /// - Returns: The implementation's return value.
    func callAsFunction(description: MockImplementationDescription) throws -> Value {
        switch self {
        case .unimplemented:
            XCTestDynamicOverlay.unimplemented("\(description)")
        case let .returns(value):
            value
        case let .throws(error):
            throw error
        }
    }
}
