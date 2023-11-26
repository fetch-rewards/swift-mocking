//
//  MockReadOnlyAsyncThrowingVariable.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's read-only, async,
/// throwing variable.
public final class MockReadOnlyAsyncThrowingVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter: MockVariableAsyncThrowingGetter<Value>

    // MARK: Initializers

    /// Creates a read-only, async, throwing variable.
    private init(description: MockImplementationDescription) {
        self.getter = MockVariableAsyncThrowingGetter(description: description)
    }

    // MARK: Factories

    /// Creates a new variable and an async throwing closure to invoke the
    /// variable's getter, returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new variable and an async throwing
    /// closure to invoke the variable's getter.
    public static func makeVariable(
        description: MockImplementationDescription
    ) -> (
        variable: MockReadOnlyAsyncThrowingVariable,
        get: () async throws -> Value
    ) {
        let variable = Self(description: description)

        return (
            variable: variable,
            get: { try await variable.getter.get() }
        )
    }
}
