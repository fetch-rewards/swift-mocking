//
//  MockVoidThrowingFunctionWithoutParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's void, throwing
/// function that does not have parameters.
public struct MockVoidThrowingFunctionWithoutParameters {

    // MARK: Properties

    /// The error thrown by the function.
    public var error: Error?

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the errors that have been thrown by the function.
    public private(set) var errors: [Error] = []

    // MARK: Initializers

    /// Creates a void, throwing function without parameters.
    private init() {}

    // MARK: Factories

    /// Creates a new function and a throwing closure to invoke the function,
    /// returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new function and a throwing closure to
    ///   invoke the function.
    public static func makeFunction(
    ) -> (
        function: Self,
        invoke: () throws -> Void
    ) {
        var function = Self()

        return (
            function: function,
            invoke: { try function.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and throws an error if ``error``
    /// is not `nil`.
    ///
    /// - Throws: ``error``, if it is not `nil`.
    private mutating func invoke() throws {
        self.callCount += 1

        guard let error = self.error else { return }

        self.errors.append(error)

        throw error
    }
}
