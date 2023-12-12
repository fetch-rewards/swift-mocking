//
//  MockVariableAsyncThrowingGetter.swift
//  Mocked
//
//  Created by Cole Campbell on 11/12/23.
//

import Foundation

/// The implementation details and invocation records for a variable's async,
/// throwing getter.
public final class MockVariableAsyncThrowingGetter<Value> {

    // MARK: Properties

    /// The getter's implementation.
    public var implementation: MockAsyncThrowingImplementation<Value> = .unimplemented

    /// The number of times the getter has been called.
    public private(set) var callCount: Int = .zero

    /// The description of the mock's exposed variable.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed variable needs an implementation for the test
    /// to succeed.
    private let exposedVariableDescription: MockImplementationDescription

    // MARK: Initializers

    /// Creates an async throwing variable getter.
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
    func get() async throws -> Value {
        self.callCount += 1

        return try await self.implementation(description: self.exposedVariableDescription)
    }
}
