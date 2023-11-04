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
    public init() {}

    // MARK: Invoke

    /// Records the invocation of the function and throws an error if ``error``
    /// is not `nil`.
    ///
    /// - Important: This method should only be called from a mock's
    ///   function conformance declaration. Unless you are writing an
    ///   implementation for a mock, you should never call this method
    ///   directly.
    /// - Throws: ``error``, if it is not `nil`.
    public mutating func invoke() throws {
        self.callCount += 1

        guard let error = self.error else { return }

        self.errors.append(error)

        throw error
    }
}
