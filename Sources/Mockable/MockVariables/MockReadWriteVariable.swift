//
//  MockReadWriteVariable.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's read-write
/// variable.
public final class MockReadWriteVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter: MockVariableGetter<Value>

    /// The variable's setter.
    public var setter = MockVariableSetter<Value>()

    // MARK: Initializers

    /// Creates a read-write variable.
    ///
    /// - Parameter exposedVariableDescription: The description of the mock's
    ///   exposed variable.
    private init(exposedVariableDescription: MockImplementationDescription) {
        self.getter = MockVariableGetter(
            exposedVariableDescription: exposedVariableDescription
        )
    }

    // MARK: Factories

    /// Creates a variable, a closure for invoking the variable's getter, and a
    /// closure for invoking the variable's setter, returning them in a labeled
    /// tuple.
    ///
    /// - Parameter exposedVariableDescription: The description of the mock's
    ///   exposed variable.
    /// - Returns: A tuple containing a variable, a closure for invoking the
    ///   variable's getter, and a closure for invoking the variable's setter.
    public static func makeVariable(
        exposedVariableDescription: MockImplementationDescription
    ) -> (
        variable: MockReadWriteVariable,
        get: () -> Value,
        set: (Value) -> Void
    ) {
        let variable = MockReadWriteVariable(
            exposedVariableDescription: exposedVariableDescription
        )

        return (
            variable: variable,
            get: { variable.getter.get() },
            set: { variable.setter.set($0) }
        )
    }
}
