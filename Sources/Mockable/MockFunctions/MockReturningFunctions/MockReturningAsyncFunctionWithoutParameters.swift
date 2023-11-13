//
//  MockReturningAsyncFunctionWithoutParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import XCTestDynamicOverlay

/// The invocation records and implementation for a mock's returning, async
/// function that does not have parameters.
public final class MockReturningAsyncFunctionWithoutParameters<ReturnValue> {

    // MARK: Properties

    /// The function's implementation.
    public var implementation: MockAsyncImplementation<ReturnValue> = .unimplemented

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the function.
    public private(set) var returnValues: [ReturnValue] = []

    /// The latest value returned by the function.
    public private(set) var latestReturnValue: ReturnValue?

    /// The keypath for the mock's backing variable.
    private let keyPath: AnyKeyPath

    // MARK: Initializers

    /// Creates a returning, async function without parameters.
    private init(
        keyPath: AnyKeyPath
    ) {
        self.keyPath = keyPath
    }

    // MARK: Factories

    /// Creates a new function and an async closure to invoke the function,
    /// returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new function and an async closure to
    /// invoke the function.
    public static func makeFunction(
        for keyPath: AnyKeyPath
    ) -> (
        function: MockReturningAsyncFunctionWithoutParameters,
        invoke: () async -> ReturnValue
    ) {
        let function = Self(keyPath: keyPath)

        return (
            function: function,
            invoke: { await function.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and returns the function's return
    /// value.
    ///
    /// - Returns: The function's return value.
    private func invoke() async -> ReturnValue {
        self.callCount += 1

        let returnValue = await self.implementation(for: self.keyPath)

        self.returnValues.append(returnValue)
        self.latestReturnValue = returnValue

        return returnValue
    }
}
