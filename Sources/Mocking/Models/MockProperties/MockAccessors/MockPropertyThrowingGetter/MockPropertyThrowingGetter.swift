//
//  MockPropertyThrowingGetter.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Locking

/// A mock property getter that contains implementation details and invocation
/// records for a throwing property getter.
public final class MockPropertyThrowingGetter<Value> {

    // MARK: State

    /// All invocation records; grouped so reads and writes across them are atomic.
    private struct State {
        var callCount: Int = .zero
        var returnedValues: [Result<Value, any Error>] = []
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
    public var returnedValues: [Result<Value, any Error>] {
        self._state.withLockUnchecked { state in
            state.returnedValues
        }
    }

    /// The last value returned by the getter.
    public var lastReturnedValue: Result<Value, any Error>? {
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
    /// invocation records for a throwing property getter.
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
    /// - Throws: An error, if ``implementation-swift.property`` throws an
    ///   error.
    /// - Returns: A value, if ``implementation-swift.property`` returns a
    ///   value.
    func get() throws -> Value {
        let value = Result {
            guard let value = try self.implementation() else {
                fatalError("Unimplemented: \(self.exposedPropertyDescription)")
            }

            return value
        }

        self._state.withLockUnchecked { state in
            state.callCount += 1
            state.returnedValues.append(value)
        }

        return try value.get()
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

extension MockPropertyThrowingGetter: Sendable where Value: Sendable {}
