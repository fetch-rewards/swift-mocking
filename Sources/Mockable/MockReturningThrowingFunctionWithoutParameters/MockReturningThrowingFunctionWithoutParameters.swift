//
//  MockReturningThrowingFunctionWithoutParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import XCTestDynamicOverlay

/// The invocation records and implementation for a mock's returning, throwing
/// function that does not have parameters.
public struct MockReturningThrowingFunctionWithoutParameters<ReturnValue> {

    // MARK: Properties

    /// The function's return value.
    public var returnValue: Result<ReturnValue, Error>?

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the function.
    public private(set) var returnValues: [Result<ReturnValue, Error>] = []

    /// The latest value returned by the function.
    public private(set) var latestReturnValue: Result<ReturnValue, Error>?

    // MARK: Initializers

    /// Creates a returning, throwing function without parameters.
    public init() {}

    // MARK: Invoke

    /// Records the invocation of the function and returns the function's return
    /// value or throws an error.
    ///
    /// - Important: This method should only be called from a mock's
    ///   function conformance declaration. Unless you are writing an
    ///   implementation for a mock, you should never call this method
    ///   directly.
    /// - Throws: An error, if ``returnValue`` is `.failure`.
    /// - Returns: The function's return value.
    public mutating func invoke() throws -> ReturnValue {
        guard let returnValue = self.returnValue else {
            return unimplemented("\(Self.self).returnValue")
        }

        self.callCount += 1
        self.returnValues.append(returnValue)
        self.latestReturnValue = returnValue

        return try returnValue.get()
    }
}
