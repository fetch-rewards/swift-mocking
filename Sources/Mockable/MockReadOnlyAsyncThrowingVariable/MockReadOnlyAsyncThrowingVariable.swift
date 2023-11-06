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

    public static func makeVariable(
    ) -> (
        variable: Self,
        get: () async throws -> Value
    ) {
        var variable = Self()

        return (variable, { try await variable.getter.get() })
    }
}
