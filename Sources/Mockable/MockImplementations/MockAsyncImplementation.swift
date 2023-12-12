//
//  MockAsyncImplementation.swift
//  Mockable
//
//  Created by Cole Campbell on 11/11/23.
//

import Foundation
import XCTestDynamicOverlay

/// A mock's async implementation.
public enum MockAsyncImplementation<Value> {

    // MARK: Cases

    /// Triggers a test failure when invoked.
    case unimplemented

    /// Returns a value when invoked.
    case returns(() async -> Value)

    // MARK: Call As Function

    /// Invokes the implementation, triggering a test failure if the
    /// implementation is ``MockAsyncImplementation/unimplemented`` or returning
    /// a value if the implementation is ``MockAsyncImplementation/returns(_:)``.
    ///
    /// - Parameter description: The implementation's description.
    /// - Returns: A value if the implementation is
    ///   ``MockAsyncImplementation/returns(_:)``.
    func callAsFunction(description: MockImplementationDescription) async -> Value {
        switch self {
        case .unimplemented:
            XCTestDynamicOverlay.unimplemented("\(description)")
        case let .returns(value):
            await value()
        }
    }
}
