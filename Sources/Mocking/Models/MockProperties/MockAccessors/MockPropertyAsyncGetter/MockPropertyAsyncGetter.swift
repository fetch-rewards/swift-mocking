//
//  MockPropertyAsyncGetter.swift
//  Mocking
//
//  Created by Cole Campbell on 11/12/23.
//

import Foundation
import Synchronization

/// A mock property getter that contains implementation details and invocation
/// records for an async property getter.
public final class MockPropertyAsyncGetter<Value> {

    // MARK: Properties

    /// The getter's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the getter has been called.
    @Locked(.unchecked)
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
        self.callCount += 1

        guard let value = await self.implementation() else {
            fatalError("Unimplemented: \(self.exposedPropertyDescription)")
        }

        self.returnedValues.append(value)

        return value
    }

    // MARK: Reset

    /// Resets the getter's implementation and invocation records.
    func reset() {
        self.implementation = .unimplemented
        self.callCount = .zero
        self.returnedValues.removeAll()
    }
}

// MARK: - Sendable

extension MockPropertyAsyncGetter: Sendable where Value: Sendable {}
