//
//  MockImplementation.swift
//  Mockable
//
//  Created by Cole Campbell on 11/11/23.
//

import Foundation
import XCTestDynamicOverlay

/// A mock's implementation.
public enum MockImplementation<Value> {

    // MARK: Cases

    /// Triggers a test failure when invoked.
    case unimplemented

    /// Returns a value when invoked.
    case returns(Value)

    // MARK: Call As Function

    /// Invokes the implementation, triggering a test failure if the
    /// implementation is ``MockImplementation/unimplemented`` or returning a
    /// value if the implementation is ``MockImplementation/returns(_:)``.
    ///
    /// - Parameter description: The implementation's description.
    /// - Returns: A value if the implementation is
    ///   ``MockImplementation/returns(_:)``.
    func callAsFunction(description: MockImplementationDescription) -> Value {
        switch self {
        case .unimplemented:
            XCTestDynamicOverlay.unimplemented("\(description)")
        case let .returns(value):
            value
        }
    }
}
