//
//  MockReadOnlyVariable.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's read-only variable.
public final class MockReadOnlyVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter: MockVariableGetter<Value>

    // MARK: Initializers

    /// Creates a read-only variable.
    private init(
        keyPath: AnyKeyPath
    ) {
        self.getter = MockVariableGetter(for: keyPath)
    }

    // MARK: Factories

    /// Creates a new variable and a closure to invoke the variable's getter,
    /// returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new variable and a closure to invoke the
    /// variable's getter.
    public static func makeVariable(
        for keyPath: AnyKeyPath
    ) -> (
        variable: MockReadOnlyVariable,
        get: () -> Value
    ) {
        let variable = Self(keyPath: keyPath)

        return (
            variable: variable,
            get: { variable.getter.get() }
        )
    }
}
