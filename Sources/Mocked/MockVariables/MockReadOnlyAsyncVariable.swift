//
//  MockReadOnlyAsyncVariable.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's read-only,
/// async variable.
public final class MockReadOnlyAsyncVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter: MockVariableAsyncGetter<Value>

    // MARK: Initializers

    /// Creates a read-only, async variable.
    ///
    /// - Parameter exposedVariableDescription: The description of the mock's
    ///   exposed variable.
    private init(exposedVariableDescription: MockImplementationDescription) {
        self.getter = MockVariableAsyncGetter(
            exposedVariableDescription: exposedVariableDescription
        )
    }

    // MARK: Factories

    /// Creates a variable and an async closure for invoking the variable's
    /// getter, returning them in a labeled tuple.
    ///
    /// - Parameter exposedVariableDescription: The description of the mock's
    ///   exposed variable.
    /// - Returns: A tuple containing a variable and an async closure for
    ///   invoking the variable's getter.
    public static func makeVariable(
        exposedVariableDescription: MockImplementationDescription
    ) -> (
        variable: MockReadOnlyAsyncVariable,
        get: () async -> Value
    ) {
        let variable = MockReadOnlyAsyncVariable(
            exposedVariableDescription: exposedVariableDescription
        )

        return (
            variable: variable,
            get: { await variable.getter.get() }
        )
    }
}
