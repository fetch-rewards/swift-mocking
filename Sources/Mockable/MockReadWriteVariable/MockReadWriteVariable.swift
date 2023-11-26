//
//  MockReadWriteVariable.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's read-write variable.
public struct MockReadWriteVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter = Getter()

    /// The variable's setter.
    public var setter = Setter()

    // MARK: Initializers

    /// Creates a read-write variable.
    private init() {}

    // MARK: Factories

    /// Creates a new variable, a closure to invoke the variable's getter, and a
    /// closure to invoke the variable's setter, returning them in a labeled
    /// tuple.
    ///
    /// - Returns: A tuple containing a new variable, a closure to invoke the
    ///   variable's getter, and a closure to invoke the variable's setter.
    public static func makeVariable(
    ) -> (
        variable: Self,
        get: () -> Value,
        set: (Value) -> Void
    ) {
        var variable = Self()

        return (
            variable: variable,
            get: { variable.getter.get() },
            set: { variable.setter.set($0) }
        )
    }
}
