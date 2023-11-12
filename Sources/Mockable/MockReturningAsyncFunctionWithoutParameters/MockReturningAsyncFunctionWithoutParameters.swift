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
public struct MockReturningAsyncFunctionWithoutParameters<ReturnValue> {

    // MARK: Properties

    /// The function's return value.
    public var returnValue: ReturnValue?

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the function.
    public private(set) var returnValues: [ReturnValue] = []

    /// The latest value returned by the function.
    public private(set) var latestReturnValue: ReturnValue?

    // MARK: Initializers

    /// Creates a returning, async function without parameters.
    private init() {}

    // MARK: Factories

    /// Creates a new function and an async closure to invoke the function,
    /// returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new function and an async closure to
    /// invoke the function.
    public static func makeFunction(
    ) -> (
        function: Self,
        invoke: () async -> ReturnValue
    ) {
        var function = Self()

        return (
            function,
            { await function.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and returns the function's return
    /// value.
    ///
    /// - Returns: The function's return value.
    private mutating func invoke() async -> ReturnValue {
        guard let returnValue = self.returnValue else {
            return unimplemented("\(Self.self).returnValue")
        }

        self.callCount += 1
        self.returnValues.append(returnValue)
        self.latestReturnValue = returnValue

        return returnValue
    }
}
