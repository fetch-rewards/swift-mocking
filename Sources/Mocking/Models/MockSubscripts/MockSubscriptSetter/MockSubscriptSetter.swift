//
//  MockSubscriptSetter.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Locking

/// A mock subscript setter that contains implementation details and invocation
/// records for a subscript setter.
public final class MockSubscriptSetter<Arguments, Value> {

    // MARK: State

    /// All invocation records; grouped so reads and writes across them are atomic.
    private struct State {
        var callCount: Int = .zero
        var invocations: [(Arguments, Value)] = []
    }

    // MARK: Properties

    /// Single lock for all invocation state; prevents torn reads between state properties.
    private let _state = OSAllocatedUnfairLock(uncheckedState: State())

    /// The setter's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the setter has been called.
    public var callCount: Int {
        self._state.withLockUnchecked { state in
            state.callCount
        }
    }

    /// All the (key, value) pairs with which the setter has been invoked.
    public var invocations: [(Arguments, Value)] {
        self._state.withLockUnchecked { state in
            state.invocations
        }
    }

    /// The last (key, value) pair with which the setter was invoked.
    public var lastInvocation: (Arguments, Value)? {
        self._state.withLockUnchecked { state in
            state.invocations.last
        }
    }

    // MARK: Set

    /// Records the invocation of the setter and invokes
    /// ``implementation-swift.property``.
    ///
    /// - Parameters:
    ///   - arguments: The arguments with which the setter is being invoked.
    ///   - newValue: The value with which the setter is being invoked.
    func set(_ arguments: Arguments, _ newValue: Value) {
        self._state.withLockUnchecked { state in
            state.callCount += 1
            state.invocations.append((arguments, newValue))
        }
        self.implementation(arguments, newValue)
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

extension MockSubscriptSetter: Sendable where Arguments: Sendable, Value: Sendable {}
