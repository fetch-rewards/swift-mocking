//
//  MockVariableGetter.swift
//  Mockable
//
//  Created by Cole Campbell on 11/12/23.
//

import Foundation

/// The implementation details and invocation records for a variable's getter.
public final class MockVariableGetter<Value> {

    // MARK: Properties

    /// The getter's implementation.
    public var implementation: MockImplementation<Value> = .unimplemented

    /// The number of times the getter has been called.
    public private(set) var callCount: Int = .zero

    /// The description of the mock's exposed variable.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed variable needs an implementation for the test
    /// to succeed.
    private let description: MockImplementationDescription

    // MARK: Initializers

    /// Creates a variable getter.
    ///
    /// - Parameter description: The description of the mock's exposed variable.
    init(description: MockImplementationDescription) {
        self.description = description
    }

    // MARK: Get

    /// Records the invocation of the variable's getter and returns the
    /// variable's value.
    ///
    /// - Returns: The variable's value.
    func get() -> Value {
        self.callCount += 1

        return self.implementation(description: self.description)
    }
}
