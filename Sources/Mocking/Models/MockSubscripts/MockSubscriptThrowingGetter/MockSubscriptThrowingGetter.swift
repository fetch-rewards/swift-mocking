//
//  MockSubscriptThrowingGetter.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Locking

/// A mock subscript getter that contains implementation details and invocation
/// records for a throwing subscript getter.
public final class MockSubscriptThrowingGetter<Arguments, Value> {

    // MARK: State

    /// All invocation records; grouped so reads and writes across them are atomic.
    private struct State {
        var callCount: Int = .zero
        var invocations: [Arguments] = []
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

    /// All the arguments with which the getter has been invoked.
    public var invocations: [Arguments] {
        self._state.withLockUnchecked { state in
            state.invocations
        }
    }

    /// The last arguments with which the getter was invoked.
    public var lastInvocation: Arguments? {
        self._state.withLockUnchecked { state in
            state.invocations.last
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

    /// The description of the mock's exposed subscript.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed subscript needs an implementation for the test
    /// to succeed.
    private let exposedSubscriptDescription: MockImplementationDescription

    // MARK: Initializers

    /// Creates a mock subscript getter that contains implementation details and
    /// invocation records for a throwing subscript getter.
    ///
    /// - Parameter exposedSubscriptDescription: The description of the mock's
    ///   exposed subscript.
    init(exposedSubscriptDescription: MockImplementationDescription) {
        self.exposedSubscriptDescription = exposedSubscriptDescription
    }

    // MARK: Get

    /// Records the invocation of the getter and invokes
    /// ``implementation-swift.property``.
    ///
    /// - Parameter arguments: The arguments with which the getter is being invoked.
    /// - Throws: An error, if ``implementation-swift.property`` throws an
    ///   error.
    /// - Returns: A value, if ``implementation-swift.property`` returns a value.
    func get(_ arguments: Arguments) throws -> Value {
        let value = Result {
            guard let value = try self.implementation(arguments) else {
                fatalError("Unimplemented: \(self.exposedSubscriptDescription)")
            }

            return value
        }

        self._state.withLockUnchecked { state in
            state.callCount += 1
            state.invocations.append(arguments)
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
            state.invocations.removeAll()
            state.returnedValues.removeAll()
        }
    }
}

// MARK: - Sendable

extension MockSubscriptThrowingGetter: Sendable where Arguments: Sendable, Value: Sendable {}
