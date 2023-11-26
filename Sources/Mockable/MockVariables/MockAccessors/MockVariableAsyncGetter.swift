//
//  MockVariableAsyncGetter.swift
//  Mockable
//
//  Created by Cole Campbell on 11/12/23.
//

import Foundation

/// The invocation records and implementation for an async variable's getter.
public final class MockVariableAsyncGetter<Value> {

    // MARK: Properties

    /// The getter's implementation.
    public var implementation: MockAsyncImplementation<Value> = .unimplemented

    /// The number of times the getter has been called.
    public private(set) var callCount: Int = .zero

    /// The description of the mock's backing variable.
    private let description: MockImplementationDescription

    // MARK: Initializers

    /// Creates an async variable getter.
    init(
        description: MockImplementationDescription
    ) {
        self.description = description
    }

    // MARK: Get

    /// Records the invocation of the variable's getter and returns the
    /// variable's value.
    ///
    /// - Returns: The variable's value.
    func `get`() async -> Value {
        self.callCount += 1

        return await self.implementation(description: self.description)
    }
}
