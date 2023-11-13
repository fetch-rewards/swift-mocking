//
//  MockReadOnlyThrowingVariable.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's read-only, throwing
/// variable.
public final class MockReadOnlyThrowingVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter: MockVariableThrowingGetter<Value>

    // MARK: Initializers

    /// Creates a read-only, throwing variable.
    private init(
        keyPath: AnyKeyPath
    ) {
        self.getter = MockVariableThrowingGetter(for: keyPath)
    }

    // MARK: Factories

    /// Creates a new variable and a throwing closure to invoke the variable's
    /// getter, returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new variable and a throwing closure to
    /// invoke the variable's getter.
    public static func makeVariable(
        for keyPath: AnyKeyPath
    ) -> (
        variable: MockReadOnlyThrowingVariable,
        get: () throws -> Value
    ) {
        let variable = Self(keyPath: keyPath)

        return (
            variable: variable,
            get: { try variable.getter.get() }
        )
    }
}
