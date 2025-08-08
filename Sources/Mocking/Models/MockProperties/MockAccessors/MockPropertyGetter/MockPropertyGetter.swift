//
//  MockPropertyGetter.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
import Locking

/// A mock property getter that contains implementation details and invocation
/// records for a property getter.
public final class MockPropertyGetter<Value> {

    // MARK: Properties

    /// The getter's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the getter has been called.
    @Locked(.checked)
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the getter.
    @Locked(.unchecked)
    public private(set) var returnedValues: [Value] = []

    /// The last value returned by the getter.
    public var lastReturnedValue: Value? {
        self.returnedValues.last
    }

    /// The description of the mock's exposed property.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed property needs an implementation for the test
    /// to succeed.
    private let exposedPropertyDescription: MockImplementationDescription

    // MARK: Initializers

    /// Creates a mock property getter that contains implementation details and
    /// invocation records for a property getter.
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
    func get() -> Value {
        self._callCount.withLock { callCount in
            callCount += 1
        }

        guard let value = self.implementation() else {
            fatalError("Unimplemented: \(self.exposedPropertyDescription)")
        }

        self._returnedValues.withLockUnchecked { returnedValues in
            returnedValues.append(value)
        }

        return value
    }

    // MARK: Reset

    /// Resets the getter's implementation and invocation records.
    func reset() {
        self._implementation.withLockUnchecked { implementation in
            implementation = .unimplemented
        }
        self._callCount.withLock { callCount in
            callCount = .zero
        }
        self._returnedValues.withLockUnchecked { returnedValues in
            returnedValues.removeAll()
        }
    }
}

// MARK: - Sendable

extension MockPropertyGetter: Sendable where Value: Sendable {}
