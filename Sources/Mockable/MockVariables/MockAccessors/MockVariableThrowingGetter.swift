//
//  MockVariableThrowingGetter.swift
//  Mockable
//
//  Created by Cole Campbell on 11/12/23.
//

import Foundation

/// The invocation records and implementation for a throwing variable's getter.
public final class MockVariableThrowingGetter<Value> {

    // MARK: Properties

    /// The getter's implementation.
    public var implementation: MockThrowingImplementation<Value> = .unimplemented

    /// The number of times the getter has been called.
    public private(set) var callCount: Int = .zero

    /// The description of the mock's backing variable.
    private let description: MockImplementationDescription

    // MARK: Initializers

    /// Creates a throwing variable getter.
    init(
        description: MockImplementationDescription
    ) {
        self.description = description
    }

    // MARK: Get

    /// Records the invocation of the variable's getter and returns the
    /// variable's value or throws an error.
    ///
    /// - Returns: The variable's value.
    func `get`() throws -> Value {
        self.callCount += 1

        return try self.implementation(description: self.description)
    }
}
