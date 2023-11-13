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
public final class MockReturningThrowingFunctionWithoutParameters<ReturnValue> {

    // MARK: Properties

    /// The function's implementation.
    public var implementation: MockThrowingImplementation<ReturnValue> = .unimplemented

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the function.
    public private(set) var returnValues: [Result<ReturnValue, Error>] = []

    /// The latest value returned by the function.
    public private(set) var latestReturnValue: Result<ReturnValue, Error>?

    /// The keypath for the mock's backing variable.
    private let keyPath: AnyKeyPath

    // MARK: Initializers

    /// Creates a returning, throwing function without parameters.
    private init(
        keyPath: AnyKeyPath
    ) {
        self.keyPath = keyPath
    }

    // MARK: Factories

    /// Creates a new function and a throwing closure to invoke the function,
    /// returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new function and a throwing closure to
    /// invoke the function.
    public static func makeFunction(
        for keyPath: AnyKeyPath
    ) -> (
        function: MockReturningThrowingFunctionWithoutParameters,
        invoke: () throws -> ReturnValue
    ) {
        let function = Self(keyPath: keyPath)

        return (
            function: function,
            invoke: { try function.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and returns the function's return
    /// value or throws an error.
    ///
    /// - Throws: An error, if ``returnValue`` is `.failure`.
    /// - Returns: The function's return value.
    private func invoke() throws -> ReturnValue {
        self.callCount += 1

        let returnValue = Result {
            try self.implementation(for: self.keyPath)
        }

        self.returnValues.append(returnValue)
        self.latestReturnValue = returnValue

        return try returnValue.get()
    }
}
