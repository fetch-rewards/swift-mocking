//
//  MockPropertyAsyncThrowingGetter.swift
//
//  Created by Cole Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation
import Synchronization

/// A mock property getter that contains implementation details and invocation
/// records for an async, throwing property getter.
public final class MockPropertyAsyncThrowingGetter<Value> {

    // MARK: Properties

    /// The getter's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the getter has been called.
    @Locked(.unchecked)
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the getter.
    @Locked(.unchecked)
    public private(set) var returnedValues: [Result<Value, any Error>] = []

    /// The last value returned by the getter.
    public var lastReturnedValue: Result<Value, any Error>? {
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
    /// invocation records for an async, throwing property getter.
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
    func get() async throws -> Value {
        self.callCount += 1

        let value = await Result {
            guard let value = try await self.implementation() else {
                fatalError("Unimplemented: \(self.exposedPropertyDescription)")
            }

            return value
        }

        self.returnedValues.append(value)

        return try value.get()
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

extension MockPropertyAsyncThrowingGetter: Sendable where Value: Sendable {}
