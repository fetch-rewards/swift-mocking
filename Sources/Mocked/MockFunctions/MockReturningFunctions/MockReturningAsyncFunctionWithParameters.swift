//
//  MockReturningAsyncFunctionWithParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's returning,
/// async function with parameters.
public final class MockReturningAsyncFunctionWithParameters<Arguments, ReturnValue> {

    // MARK: Properties

    /// The function's implementation.
    public var implementation: MockAsyncImplementation<ReturnValue> = .unimplemented

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the function has been invoked.
    public private(set) var invocations: [Arguments] = []

    /// The last arguments with which the function has been invoked.
    public var lastInvocation: Arguments? {
        self.invocations.last
    }

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

    /// Creates a returning, async function with parameters.
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
    /// private let __user = MockReturningAsyncFunctionWithParameters<(User.ID), User>.makeFunction(
    ///     exposedFunctionDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReturningAsyncFunctionWithParameters<(User.ID), User> {
    ///     self.__user.function
    /// }
    ///
    /// public func user(id: User.ID) async -> User {
    ///     await self.__user.invoke((id))
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
        function: MockReturningAsyncFunctionWithParameters,
        invoke: (Arguments) async -> ReturnValue
    ) {
        let function = MockReturningAsyncFunctionWithParameters(
            exposedFunctionDescription: exposedFunctionDescription
        )

        return (
            function: function,
            invoke: { await function.invoke($0) }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and returns the function's return
    /// value.
    ///
    /// - Parameter arguments: The arguments with which the function is being
    ///   invoked.
    /// - Returns: The function's return value.
    private func invoke(_ arguments: Arguments) async -> ReturnValue {
        self.callCount += 1
        self.invocations.append(arguments)

        let returnValue = await self.implementation(description: self.exposedFunctionDescription)

        self.returnedValues.append(returnValue)

        return returnValue
    }
}
