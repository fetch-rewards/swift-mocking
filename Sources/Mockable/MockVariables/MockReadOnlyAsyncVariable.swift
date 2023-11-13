//
//  MockReadOnlyAsyncVariable.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's read-only, async
/// variable.
public final class MockReadOnlyAsyncVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter: MockVariableAsyncGetter<Value>

    // MARK: Initializers

    /// Creates a read-only, async variable.
    private init(
        keyPath: AnyKeyPath
    ) {
        self.getter = MockVariableAsyncGetter(for: keyPath)
    }

    // MARK: Factories

    /// Creates a new variable and an async closure to invoke the variable's
    /// getter, returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new variable and an async closure to
    /// invoke the variable's getter.
    public static func makeVariable(
        for keyPath: AnyKeyPath
    ) -> (
        variable: MockReadOnlyAsyncVariable,
        get: () async -> Value
    ) {
        let variable = Self(keyPath: keyPath)

        return (
            variable: variable,
            get: { await variable.getter.get() }
        )
    }
}
