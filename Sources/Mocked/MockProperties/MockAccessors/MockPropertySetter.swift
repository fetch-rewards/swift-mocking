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

    /// The number of times the setter has been called.
    public private(set) var callCount: Int = .zero

    /// All the values with which the setter has been invoked.
    public private(set) var invocations: [Value] = []

    /// The last value with which the setter has been invoked.
    public var lastInvocation: Value? {
        self.invocations.last
    }

    // MARK: Set

    /// Records the invocation of the property's setter and sets the property's
    /// value to the provided value.
    ///
    /// - Parameter newValue: The value to which to set the property's value.
    func set(_ newValue: Value) {
        self.callCount += 1
        self.invocations.append(newValue)
    }
}
