//
//  MockPropertySetter.swift
//
//  Created by Cole Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation
import Synchronization

/// A mock property setter that contains implementation details and invocation
/// records for a property setter.
public final class MockPropertySetter<Value> {

    // MARK: Properties

    /// The setter's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the setter has been called.
    @Locked(.unchecked)
    public private(set) var callCount: Int = .zero

    /// All the values with which the setter has been invoked.
    @Locked(.unchecked)
    public private(set) var invocations: [Value] = []

    /// The last value with which the setter has been invoked.
    public var lastInvocation: Value? {
        self.invocations.last
    }

    // MARK: Set

    /// Records the invocation of the method and invokes
    /// ``implementation-swift.property``.
    ///
    /// - Parameter value: The value with which the setter is being invoked.
    func set(_ value: Value) {
        self.callCount += 1
        self.invocations.append(value)
        self.implementation(value)
    }

    // MARK: Reset

    /// Resets the setter's implementation and invocation records.
    func reset() {
        self.implementation = .unimplemented
        self.callCount = .zero
        self.invocations.removeAll()
    }
}

// MARK: - Sendable

extension MockPropertySetter: Sendable where Value: Sendable {}
