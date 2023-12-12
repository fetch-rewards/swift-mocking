//
//  MockReadOnlyAsyncThrowingVariable.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's read-only,
/// async, throwing variable.
public final class MockReadOnlyAsyncThrowingVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter: MockVariableAsyncThrowingGetter<Value>

    // MARK: Initializers

    /// Creates a read-only, async, throwing variable.
    ///
    /// - Parameter exposedVariableDescription: The description of the mock's
    ///   exposed variable.
    private init(exposedVariableDescription: MockImplementationDescription) {
        self.getter = MockVariableAsyncThrowingGetter(
            exposedVariableDescription: exposedVariableDescription
        )
    }

    // MARK: Factories

    /// Creates a variable and an async throwing closure for invoking the
    /// variable's getter, returning them in a labeled tuple.
    ///
    /// - Parameter exposedVariableDescription: The description of the mock's
    ///   exposed variable.
    /// - Returns: A tuple containing a variable and an async throwing closure
    ///   for invoking the variable's getter.
    public static func makeVariable(
        exposedVariableDescription: MockImplementationDescription
    ) -> (
        variable: MockReadOnlyAsyncThrowingVariable,
        get: () async throws -> Value
    ) {
        let variable = MockReadOnlyAsyncThrowingVariable(
            exposedVariableDescription: exposedVariableDescription
        )

        return (
            variable: variable,
            get: { try await variable.getter.get() }
        )
    }
}
