//
//  MockReturningFunctionWithoutParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import XCTestDynamicOverlay

/// The invocation records and implementation for a mock's returning function
/// that does not have parameters.
public final class MockReturningFunctionWithoutParameters<ReturnValue> {

    // MARK: Properties

    /// The function's implementation.
    public var implementation: MockImplementation<ReturnValue> = .unimplemented

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the function.
    public private(set) var returnValues: [ReturnValue] = []

    /// The latest value returned by the function.
    public private(set) var latestReturnValue: ReturnValue?

    /// The description of the mock's backing variable.
    private let description: MockImplementationDescription

    // MARK: Initializers

    /// Creates a returning function without parameters.
    private init(
        description: MockImplementationDescription
    ) {
        self.description = description
    }

    // MARK: Factories

    /// Creates a new function and a closure to invoke the function, returning
    /// them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new function and a closure to invoke the
    /// function.
    public static func makeFunction(
        description: MockImplementationDescription
    ) -> (
        function: MockReturningFunctionWithoutParameters,
        invoke: () -> ReturnValue
    ) {
        let function = Self(description: description)

        return (
            function: function,
            invoke: { function.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and returns the function's return
    /// value.
    ///
    /// - Returns: The function's return value.
    private func invoke() -> ReturnValue {
        self.callCount += 1

        let returnValue = self.implementation(description: self.description)

        self.returnValues.append(returnValue)
        self.latestReturnValue = returnValue

        return returnValue
    }
}
