//
//  MockPropertyGetter.swift
//  Mocked
//
//  Created by Cole Campbell on 11/12/23.
//

import Foundation

/// The implementation details and invocation records for a property's getter.
public final class MockPropertyGetter<Value> {

    // MARK: Properties

    /// The getter's implementation.
    public var implementation: MockImplementation<Value> = .unimplemented

    /// The number of times the getter has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the getter.
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

    /// Creates a property getter.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    init(exposedPropertyDescription: MockImplementationDescription) {
        self.exposedPropertyDescription = exposedPropertyDescription
    }

    // MARK: Get

    /// Records the invocation of the property's getter and returns the
    /// property's value.
    ///
    /// - Returns: The property's value.
    func get() -> Value {
        self.callCount += 1

        let value = self.implementation(description: self.exposedPropertyDescription)

        self.returnedValues.append(value)

        return value
    }
}
