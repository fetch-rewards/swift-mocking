//
//  MockReturningAsyncFunctionWithoutParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's returning,
/// async function without parameters.
public final class MockReturningAsyncFunctionWithoutParameters<ReturnValue> {

    // MARK: Properties

    /// The function's implementation.
    public var implementation: MockAsyncImplementation<ReturnValue> = .unimplemented

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the function.
    public private(set) var returnedValues: [ReturnValue] = []

    /// The last value returned by the function.
    public var lastReturnedValue: ReturnValue? {
        self.returnedValues.last
    }

    /// The description of the mock's exposed function.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed function needs an implementation for the test
    /// to succeed.
    private let exposedFunctionDescription: MockImplementationDescription

    // MARK: Initializers

    /// Creates a returning, async function without parameters.
    ///
    /// - Parameter exposedFunctionDescription: The description of the mock's
    ///   exposed function.
    private init(exposedFunctionDescription: MockImplementationDescription) {
        self.exposedFunctionDescription = exposedFunctionDescription
    }

    // MARK: Factories

    /// Creates a function and an async closure for invoking the function,
    /// returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __users = MockReturningAsyncFunctionWithoutParameters<[User]>.makeFunction(
    ///     exposedFunctionDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_users"
    ///     )
    /// )
    ///
    /// public var _users: MockReturningAsyncFunctionWithoutParameters<[User]> {
    ///     self.__users.function
    /// }
    ///
    /// public func users() async -> [User] {
    ///     await self.__users.invoke()
    /// }
    /// ```
    ///
    /// - Parameter exposedFunctionDescription: The description of the mock's
    ///   exposed function.
    /// - Returns: A tuple containing a function and an async closure for
    ///   invoking the function.
    public static func makeFunction(
        exposedFunctionDescription: MockImplementationDescription
    ) -> (
        function: MockReturningAsyncFunctionWithoutParameters,
        invoke: () async -> ReturnValue
    ) {
        let function = MockReturningAsyncFunctionWithoutParameters(
            exposedFunctionDescription: exposedFunctionDescription
        )

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

        let returnValue = await self.implementation(description: self.exposedFunctionDescription)

        self.returnedValues.append(returnValue)

        return returnValue
    }
}
