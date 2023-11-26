//
//  MockReadWriteVariable.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's read-write variable.
public final class MockReadWriteVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter: MockVariableGetter<Value>

    /// The variable's setter.
    public var setter = MockVariableSetter<Value>()

    // MARK: Initializers

    /// Creates a read-write variable.
    private init(
        description: MockImplementationDescription
    ) {
        self.getter = MockVariableGetter(description: description)
    }

    // MARK: Factories

    /// Creates a new variable, a closure to invoke the variable's getter, and a
    /// closure to invoke the variable's setter, returning them in a labeled
    /// tuple.
    ///
    /// - Returns: A tuple containing a new variable, a closure to invoke the
    /// variable's getter, and a closure to invoke the variable's setter.
    public static func makeVariable(
        description: MockImplementationDescription
    ) -> (
        variable: MockReadWriteVariable,
        get: () -> Value,
        set: (Value) -> Void
    ) {
        let variable = Self(description: description)

        return (
            variable: variable,
            get: { variable.getter.get() },
            set: { variable.setter.set($0) }
        )
    }
}
