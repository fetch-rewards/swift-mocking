//
//  MockPropertyThrowingGetter.swift
//  Mocked
//
//  Created by Cole Campbell on 11/12/23.
//

import Foundation

/// The implementation details and invocation records for a property's throwing
/// getter.
public final class MockPropertyThrowingGetter<Value> {

    // MARK: Properties

    /// The getter's implementation.
    public var implementation: MockThrowingImplementation<Value> = .unimplemented

    /// The number of times the getter has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the getter.
    public private(set) var returnedValues: [Result<Value, Error>] = []

    /// The last value returned by the getter.
    public var lastReturnedValue: Result<Value, Error>? {
        self.returnedValues.last
    }

    /// The description of the mock's exposed property.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed property needs an implementation for the test
    /// to succeed.
    private let exposedPropertyDescription: MockImplementationDescription

    // MARK: Initializers

    /// Creates a throwing property getter.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's 
    ///   exposed property.
    init(exposedPropertyDescription: MockImplementationDescription) {
        self.exposedPropertyDescription = exposedPropertyDescription
    }

    // MARK: Get

    /// Records the invocation of the property's getter and returns the
    /// property's value or throws an error.
    ///
    /// - Returns: The property's value.
    func get() throws -> Value {
        self.callCount += 1

        let value = Result {
            try self.implementation(description: self.exposedPropertyDescription)
        }

        self.returnedValues.append(value)

        return try value.get()
    }
}
