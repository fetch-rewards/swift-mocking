//
//  MockReturningThrowingFunctionWithParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's returning,
/// throwing function with parameters.
public final class MockReturningThrowingFunctionWithParameters<Arguments, ReturnValue> {

    // MARK: Properties

    /// The function's implementation.
    public var implementation: MockThrowingImplementation<ReturnValue> = .unimplemented

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the function has been invoked.
    public private(set) var invocations: [Arguments] = []

    /// The latest arguments with which the function has been invoked.
    public var latestInvocation: Arguments? {
        self.invocations.last
    }

    /// All the values that have been returned by the function.
    public private(set) var returnValues: [Result<ReturnValue, Error>] = []

    /// The latest value returned by the function.
    public var latestReturnValue: Result<ReturnValue, Error>? {
        self.returnValues.last
    }

    /// The description of the mock's exposed function.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed function needs an implementation for the test
    /// to succeed.
    private let description: MockImplementationDescription

    // MARK: Initializers

    /// Creates a returning, throwing function with parameters.
    ///
    /// - Parameter description: The description of the mock's exposed function.
    private init(description: MockImplementationDescription) {
        self.description = description
    }

    // MARK: Factories

    /// Creates a function and a throwing closure for invoking the function,
    /// returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __user = MockReturningThrowingFunctionWithParameters<(User.ID), User>.makeFunction(
    ///     description: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReturningThrowingFunctionWithParameters<(User.ID), User> {
    ///     self.__user.function
    /// }
    ///
    /// public func user(id: User.ID) throws -> User {
    ///     try self.__user.invoke((id))
    /// }
    /// ```
    ///
    /// - Parameter description: The description of the mock's exposed function.
    /// - Returns: A tuple containing a function and a throwing closure for
    ///   invoking the function.
    public static func makeFunction(
        description: MockImplementationDescription
    ) -> (
        function: MockReturningThrowingFunctionWithParameters,
        invoke: (Arguments) throws -> ReturnValue
    ) {
        let function = MockReturningThrowingFunctionWithParameters(description: description)

        return (
            function: function,
            invoke: { try function.invoke($0) }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and returns the function's return
    /// value or throws an error.
    ///
    /// - Parameter arguments: The arguments with which the function is being
    ///   invoked.
    /// - Throws: An error, if ``returnValue`` is `.failure`.
    /// - Returns: The function's return value.
    private func invoke(_ arguments: Arguments) throws -> ReturnValue {
        self.callCount += 1
        self.invocations.append(arguments)

        let returnValue = Result {
            try self.implementation(description: self.description)
        }

        self.returnValues.append(returnValue)

        return try returnValue.get()
    }
}
