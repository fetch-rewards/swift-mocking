//
//  MockPropertyAsyncThrowingGetter.swift
//  Mocked
//
//  Created by Cole Campbell on 11/12/23.
//

import Foundation

/// The implementation details and invocation records for a property's async,
/// throwing getter.
public final class MockPropertyAsyncThrowingGetter<Value> {

    // MARK: Properties

    /// The getter's implementation.
    public var implementation: Implementation = .unimplemented

    /// The number of times the getter has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the getter.
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

    /// Creates an async throwing property getter.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    init(exposedPropertyDescription: MockImplementationDescription) {
        self.exposedPropertyDescription = exposedPropertyDescription
    }

    // MARK: Get

    /// Records the invocation of the getter and invokes ``implementation``.
    ///
    /// - Throws: An error, if ``implementation`` is
    ///   ``Implementation-swift.enum/throws(_:)-swift.enum.case`` or
    ///   ``Implementation-swift.enum/throws(_:)-swift.type.method``.
    /// - Returns: A value, if ``implementation`` is
    ///   ``Implementation-swift.enum/returns(_:)-swift.enum.case`` or
    ///   ``Implementation-swift.enum/returns(_:)-swift.type.method``.
    func get() async throws -> Value {
        self.callCount += 1

        let value = await Result {
            try await self.implementation(
                description: self.exposedPropertyDescription
            )
        }

        self.returnedValues.append(value)

        return try value.get()
    }
}
