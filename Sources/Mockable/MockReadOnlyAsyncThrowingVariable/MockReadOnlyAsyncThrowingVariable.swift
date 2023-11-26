//
//  MockReadOnlyAsyncThrowingVariable.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's read-only, async,
/// throwing variable.
public struct MockReadOnlyAsyncThrowingVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter = Getter()

    // MARK: Initializers

    /// Creates a read-only, async, throwing variable.
    private init() {}

    // MARK: Factories

    /// Creates a new variable and an async throwing closure to invoke the
    /// variable's getter, returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new variable and an async throwing
    ///   closure to invoke the variable's getter.
    public static func makeVariable(
    ) -> (
        variable: Self,
        get: () async throws -> Value
    ) {
        var variable = Self()

        return (
            variable: variable,
            get: { try await variable.getter.get() }
        )
    }
}
