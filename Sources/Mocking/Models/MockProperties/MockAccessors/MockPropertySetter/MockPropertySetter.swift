//
//  MockPropertySetter.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Locking

/// A mock property setter that contains implementation details and invocation
/// records for a property setter.
public final class MockPropertySetter<Value> {

    // MARK: State

    /// Invocation tracking state.
    private struct State {
        var callCount: Int = .zero
        var invocations: [Value] = []
    }

    /// Lock protecting all invocation state.
    private let _state = OSAllocatedUnfairLock(uncheckedState: State())

    // MARK: Properties

    /// The setter's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the setter has been called.
    public var callCount: Int {
        self._state.withLockUnchecked { state in
            state.callCount
        }
    }

    /// All the values with which the setter has been invoked.
    public var invocations: [Value] {
        self._state.withLockUnchecked { state in
            state.invocations
        }
    }

    /// The last value with which the setter has been invoked.
    public var lastInvocation: Value? {
        self._state.withLockUnchecked { state in
            state.invocations.last
        }
    }

    // MARK: Set

    /// Records the invocation of the method and invokes
    /// ``implementation-swift.property``.
    ///
    /// - Parameter value: The value with which the setter is being invoked.
    func set(_ value: Value) {
        self._state.withLockUnchecked { state in
            state.callCount += 1
            state.invocations.append(value)
        }
        self.implementation(value)
    }

    // MARK: Reset

    /// Resets the setter's implementation and invocation records.
    func reset() {
        self._implementation.withLockUnchecked { implementation in
            implementation = .unimplemented
        }
        self._state.withLockUnchecked { state in
            state.callCount = .zero
            state.invocations.removeAll()
        }
    }
}

// MARK: - Sendable

extension MockPropertySetter: Sendable where Value: Sendable {}
