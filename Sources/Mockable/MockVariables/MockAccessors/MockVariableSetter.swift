//
//  MockVariableSetter.swift
//  Mockable
//
//  Created by Cole Campbell on 11/12/23.
//

import Foundation

/// The invocation records and implementation for a variable's setter.
public final class MockVariableSetter<Value> {

    // MARK: Properties

    /// The number of times the setter has been called.
    public private(set) var callCount: Int = .zero

    /// All the values with which the setter has been invoked.
    public private(set) var values: [Value] = []

    /// The latest value with which the setter has been invoked.
    public var latestValue: Value? {
        self.values.last
    }

    // MARK: Set

    /// Records the invocation of the variable's setter and sets the
    /// variable's value to the provided value.
    ///
    /// - Parameter newValue: The value to which to set the variable's
    ///   value.
    func `set`(_ newValue: Value) {
        self.callCount += 1
        self.values.append(newValue)
    }
}
