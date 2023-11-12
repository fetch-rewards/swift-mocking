//
//  MockReadOnlyAsyncVariable.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's read-only, async
/// variable.
public struct MockReadOnlyAsyncVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter = Getter()

    // MARK: Initializers

    /// Creates a read-only, async variable.
    private init() {}

    // MARK: Factories

    /// Creates a new variable and an async closure to invoke the variable's
    /// getter, returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new variable and an async closure to
    /// invoke the variable's getter.
    public static func makeVariable(
    ) -> (
        variable: Self,
        get: () async -> Value
    ) {
        var variable = Self()

        return (variable, { await variable.getter.get() })
    }
}
