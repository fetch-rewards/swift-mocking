//
//  MockReadOnlyThrowingVariable.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's read-only,
/// throwing variable.
public final class MockReadOnlyThrowingVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter: MockVariableThrowingGetter<Value>

    // MARK: Initializers

    /// Creates a read-only, throwing variable.
    ///
    /// - Parameter exposedVariableDescription: The description of the mock's
    ///   exposed variable.
    private init(exposedVariableDescription: MockImplementationDescription) {
        self.getter = MockVariableThrowingGetter(
            exposedVariableDescription: exposedVariableDescription
        )
    }

    // MARK: Factories

    /// Creates a variable and a throwing closure for invoking the variable's
    /// getter, returning them in a labeled tuple.
    ///
    /// - Parameter exposedVariableDescription: The description of the mock's
    ///   exposed variable.
    /// - Returns: A tuple containing a variable and a throwing closure for
    ///   invoking the variable's getter.
    public static func makeVariable(
        exposedVariableDescription: MockImplementationDescription
    ) -> (
        variable: MockReadOnlyThrowingVariable,
        get: () throws -> Value
    ) {
        let variable = MockReadOnlyThrowingVariable(
            exposedVariableDescription: exposedVariableDescription
        )

        return (
            variable: variable,
            get: { try variable.getter.get() }
        )
    }
}
