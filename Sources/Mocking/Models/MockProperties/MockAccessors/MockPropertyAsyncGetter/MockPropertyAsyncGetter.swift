//
//  MockPropertyAsyncGetter.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Locking

/// A mock property getter that contains implementation details and invocation
/// records for an async property getter.
public final class MockPropertyAsyncGetter<Value> {

    // MARK: State

    /// All invocation records; grouped so reads and writes across them are atomic.
    private struct State {
        var callCount: Int = .zero
        var returnedValues: [Value] = []
    }

    // MARK: Properties

    /// Single lock for all invocation state; prevents torn reads between state properties.
    private let _state = OSAllocatedUnfairLock(uncheckedState: State())

    /// The getter's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the getter has been called.
    public var callCount: Int {
        self._state.withLockUnchecked { state in
            state.callCount
        }
    }

    /// All the values that have been returned by the getter.
    public var returnedValues: [Value] {
        self._state.withLockUnchecked { state in
            state.returnedValues
        }
    }

    /// The last value returned by the getter.
    public var lastReturnedValue: Value? {
        self._state.withLockUnchecked { state in
            state.returnedValues.last
        }
    }

    /// The description of the mock's exposed property.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed property needs an implementation for the test
    /// to succeed.
    private let exposedPropertyDescription: MockImplementationDescription

    // MARK: Initializers

    /// Creates a mock property getter that contains implementation details and
    /// invocation records for an async property getter.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    init(exposedPropertyDescription: MockImplementationDescription) {
        self.exposedPropertyDescription = exposedPropertyDescription
    }

    // MARK: Get

    /// Records the invocation of the getter and invokes
    /// ``implementation-swift.property``.
    ///
    /// - Returns: A value, if ``implementation-swift.property`` returns a
    ///   value.
    func get() async -> Value {
        guard let value = await self.implementation() else {
            fatalError("Unimplemented: \(self.exposedPropertyDescription)")
        }

        self._state.withLockUnchecked { state in
            state.callCount += 1
            state.returnedValues.append(value)
        }

        return value
    }

    // MARK: Reset

    /// Resets the getter's implementation and invocation records.
    func reset() {
        self._implementation.withLockUnchecked { implementation in
            implementation = .unimplemented
        }
        self._state.withLockUnchecked { state in
            state.callCount = .zero
            state.returnedValues.removeAll()
        }
    }
}

// MARK: - Sendable

extension MockPropertyAsyncGetter: Sendable where Value: Sendable {}
