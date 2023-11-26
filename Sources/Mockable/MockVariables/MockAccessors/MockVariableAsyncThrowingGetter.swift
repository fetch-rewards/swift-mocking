//
//  MockVariableAsyncThrowingGetter.swift
//  Mockable
//
//  Created by Cole Campbell on 11/12/23.
//

import Foundation

/// The invocation records and implementation for an async throwing variable's getter.
public final class MockVariableAsyncThrowingGetter<Value> {

    // MARK: Properties

    /// The getter's implementation.
    public var implementation: MockAsyncThrowingImplementation<Value> = .unimplemented

    /// The number of times the getter has been called.
    public private(set) var callCount: Int = .zero

    /// The description of the mock's backing variable.
    private let description: MockImplementationDescription

    // MARK: Initializers

    /// Creates an async throwing variable getter.
    init(
        description: MockImplementationDescription
    ) {
        self.description = description
    }

    // MARK: Get

    /// Records the invocation of the variable's getter and returns the
    /// variable's value or throws an error.
    ///
    /// - Returns: The variable's value.
    func `get`() async throws -> Value {
        self.callCount += 1

        return try await self.implementation(description: self.description)
    }
}
