//
//  MockReturningAsyncMethodWithoutParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's returning,
/// async method without parameters.
public final class MockReturningAsyncMethodWithoutParameters<ReturnValue> {

    // MARK: Properties

    /// The method's implementation.
    public var implementation: MockAsyncImplementation<ReturnValue> = .unimplemented

    /// The number of times the method has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the method.
    public private(set) var returnedValues: [ReturnValue] = []

    /// The last value returned by the method.
    public var lastReturnedValue: ReturnValue? {
        self.returnedValues.last
    }

    /// The description of the mock's exposed method.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed method needs an implementation for the test to
    /// succeed.
    private let exposedMethodDescription: MockImplementationDescription

    // MARK: Initializers

    /// Creates a returning, async method without parameters.
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    private init(exposedMethodDescription: MockImplementationDescription) {
        self.exposedMethodDescription = exposedMethodDescription
    }

    // MARK: Factories

    /// Creates a method and an async closure for invoking the method, returning
    /// them in a labeled tuple.
    ///
    /// ```swift
    /// private let __users = MockReturningAsyncMethodWithoutParameters<[User]>.makeMethod(
    ///     exposedMethodDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_users"
    ///     )
    /// )
    ///
    /// public var _users: MockReturningAsyncMethodWithoutParameters<[User]> {
    ///     self.__users.method
    /// }
    ///
    /// public func users() async -> [User] {
    ///     await self.__users.invoke()
    /// }
    /// ```
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    /// - Returns: A tuple containing a method and an async closure for invoking
    ///   the method.
    public static func makeMethod(
        exposedMethodDescription: MockImplementationDescription
    ) -> (
        method: MockReturningAsyncMethodWithoutParameters,
        invoke: () async -> ReturnValue
    ) {
        let method = MockReturningAsyncMethodWithoutParameters(
            exposedMethodDescription: exposedMethodDescription
        )

        return (
            method: method,
            invoke: { await method.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and returns the method's return
    /// value.
    ///
    /// - Returns: The method's return value.
    private func invoke() async -> ReturnValue {
        self.callCount += 1

        let returnValue = await self.implementation(description: self.exposedMethodDescription)

        self.returnedValues.append(returnValue)

        return returnValue
    }
}
