//
//  MockPropertySetter.swift
//  Mocked
//
//  Created by Cole Campbell on 11/12/23.
//

import Foundation

/// The implementation details and invocation records for a property's setter.
public final class MockPropertySetter<Value> {

    // MARK: Properties

    /// The setter's implementation.
    public var implementation: Implementation = .unimplemented

    /// The number of times the setter has been called.
    public private(set) var callCount: Int = .zero

    /// All the values with which the setter has been invoked.
    public private(set) var invocations: [Value] = []

    /// The last value with which the setter has been invoked.
    public var lastInvocation: Value? {
        self.invocations.last
    }

    // MARK: Set

    /// Records the invocation of the method and invokes ``implementation``.
    ///
    /// - Parameter value: The value with which the setter is being invoked.
    func set(_ value: Value) {
        self.callCount += 1
        self.invocations.append(value)
        self.implementation(value: value)
    }
}
