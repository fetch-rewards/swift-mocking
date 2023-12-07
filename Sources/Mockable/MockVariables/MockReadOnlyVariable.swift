//
//  MockReadOnlyVariable.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's read-only
/// variable.
public final class MockReadOnlyVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter: MockVariableGetter<Value>

    // MARK: Initializers

    /// Creates a read-only variable.
    ///
    /// - Parameter exposedVariableDescription: The description of the mock's
    ///   exposed variable.
    private init(exposedVariableDescription: MockImplementationDescription) {
        self.getter = MockVariableGetter(
            exposedVariableDescription: exposedVariableDescription
        )
    }

    // MARK: Factories

    /// Creates a variable and a closure for invoking the variable's getter,
    /// returning them in a labeled tuple.
    ///
    /// - Parameter exposedVariableDescription: The description of the mock's
    ///   exposed variable.
    /// - Returns: A tuple containing a variable and a closure for invoking the
    ///   variable's getter.
    public static func makeVariable(
        exposedVariableDescription: MockImplementationDescription
    ) -> (
        variable: MockReadOnlyVariable,
        get: () -> Value
    ) {
        let variable = MockReadOnlyVariable(
            exposedVariableDescription: exposedVariableDescription
        )

        return (
            variable: variable,
            get: { variable.getter.get() }
        )
    }
}
