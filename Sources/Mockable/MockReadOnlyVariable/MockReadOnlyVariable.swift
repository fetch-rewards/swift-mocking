//
//  MockReadOnlyVariable.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's read-only variable.
public struct MockReadOnlyVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter = Getter()

    // MARK: Initializers

    /// Creates a read-only variable.
    private init() {}

    // MARK: Factories

    /// Creates a new variable and a closure to invoke the variable's getter,
    /// returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new variable and a closure to invoke the
    /// variable's getter.
    public static func makeVariable(
    ) -> (
        variable: Self,
        get: () -> Value
    ) {
        var variable = Self()

        return (variable, { variable.getter.get() })
    }
}
