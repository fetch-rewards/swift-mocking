//
//  MockVariableThrowingGetter.swift
//  Mocked
//
//  Created by Cole Campbell on 11/12/23.
//

import Foundation

/// The implementation details and invocation records for a variable's throwing
/// getter.
public final class MockVariableThrowingGetter<Value> {

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

    /// The description of the mock's exposed variable.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed variable needs an implementation for the test
    /// to succeed.
    private let exposedVariableDescription: MockImplementationDescription

    // MARK: Initializers

    /// Creates a throwing variable getter.
    ///
    /// - Parameter exposedVariableDescription: The description of the mock's 
    ///   exposed variable.
    init(exposedVariableDescription: MockImplementationDescription) {
        self.exposedVariableDescription = exposedVariableDescription
    }

    // MARK: Get

    /// Records the invocation of the variable's getter and returns the
    /// variable's value or throws an error.
    ///
    /// - Returns: The variable's value.
    func get() throws -> Value {
        self.callCount += 1

        let value = Result {
            try self.implementation(description: self.exposedVariableDescription)
        }

        self.returnedValues.append(value)

        return try value.get()
    }
}
