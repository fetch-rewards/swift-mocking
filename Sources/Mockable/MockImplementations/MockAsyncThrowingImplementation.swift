//
//  MockAsyncThrowingImplementation.swift
//  Mockable
//
//  Created by Cole Campbell on 11/11/23.
//

import Foundation
import XCTestDynamicOverlay

/// A mock's async, throwing implementation.
public enum MockAsyncThrowingImplementation<Value> {

    // MARK: Cases

    /// Triggers a test failure when invoked.
    case unimplemented

    /// Returns a value when invoked.
    case returns(() async -> Value)

    /// Throws an error when invoked.
    case `throws`(() async -> Error)

    // MARK: Call As Function

    /// Invokes the implementation, triggering a test failure if the
    /// implementation is ``MockAsyncThrowingImplementation/unimplemented``,
    /// returning a value if the implementation is
    /// ``MockAsyncThrowingImplementation/returns(_:)``, or throwing an error if
    /// the implementation is ``MockAsyncThrowingImplementation/throws(_:)``.
    ///
    /// - Parameter description: The implementation's description.
    /// - Throws: An error if the implementation is
    ///   ``MockAsyncThrowingImplementation/throws(_:)``.
    /// - Returns: A value if the implementation is
    ///   ``MockAsyncThrowingImplementation/returns(_:)``.
    func callAsFunction(description: MockImplementationDescription) async throws -> Value {
        switch self {
        case .unimplemented:
            XCTestDynamicOverlay.unimplemented("\(description)")
        case let .returns(value):
            await value()
        case let .throws(error):
            throw await error()
        }
    }
}
