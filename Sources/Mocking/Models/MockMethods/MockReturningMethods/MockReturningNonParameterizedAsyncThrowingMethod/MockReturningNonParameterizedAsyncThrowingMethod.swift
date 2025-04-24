//
//  MockReturningNonParameterizedAsyncThrowingMethod.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
import Synchronization

/// A mock method that contains implementation details and invocation records
/// for a returning, non-parameterized, async, throwing method.
public final class MockReturningNonParameterizedAsyncThrowingMethod<ReturnValue> {

    // MARK: Properties

    /// The method's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the method has been called.
    @Locked(.unchecked)
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the method.
    @Locked(.unchecked)
    public private(set) var returnedValues: [Result<ReturnValue, any Error>] = []

    /// The last value returned by the method.
    public var lastReturnedValue: Result<ReturnValue, any Error>? {
        self.returnedValues.last
    }

    /// The description of the mock's exposed method.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed method needs an implementation for the test to
    /// succeed.
    private let exposedMethodDescription: MockImplementationDescription

    // MARK: Initializers

    /// Creates a returning, non-parameterized, async, throwing method.
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    private init(exposedMethodDescription: MockImplementationDescription) {
        self.exposedMethodDescription = exposedMethodDescription
    }

    // MARK: Factories

    /// Creates a mock method, an async, throwing closure for invoking the mock
    /// method, and a closure for resetting the mock method, returning them
    /// in a labeled tuple.
    ///
    /// ```swift
    /// private let __users = MockReturningNonParameterizedAsyncThrowingMethod<
    ///     [User]
    /// >.makeMethod(
    ///     exposedMethodDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_users"
    ///     )
    /// )
    ///
    /// public var _users: MockReturningNonParameterizedAsyncThrowingMethod<[User]> {
    ///     self.__users.method
    /// }
    ///
    /// public func users() async throws -> [User] {
    ///     try await self.__users.invoke()
    /// }
    /// ```
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    /// - Returns: A tuple containing a mock method, an async, throwing closure
    ///   for invoking the mock method, and a closure for resetting the mock
    ///   method.
    public static func makeMethod(
        exposedMethodDescription: MockImplementationDescription
    ) -> (
        method: MockReturningNonParameterizedAsyncThrowingMethod,
        invoke: () async throws -> ReturnValue,
        reset: () -> Void
    ) {
        let method = MockReturningNonParameterizedAsyncThrowingMethod(
            exposedMethodDescription: exposedMethodDescription
        )

        return (
            method: method,
            invoke: method.invoke,
            reset: method.reset
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes
    /// ``implementation-swift.property``.
    ///
    /// - Throws: An error, if ``implementation-swift.property`` throws an
    ///   error.
    /// - Returns: A value, if ``implementation-swift.property`` returns a
    ///   value.
    private func invoke() async throws -> ReturnValue {
        self.callCount += 1

        let returnValue = await Result {
            guard let returnValue = try await self.implementation() else {
                fatalError("Unimplemented: \(self.exposedMethodDescription)")
            }

            return returnValue
        }

        self.returnedValues.append(returnValue)

        return try returnValue.get()
    }

    // MARK: Reset

    /// Resets the method's implementation and invocation records.
    private func reset() {
        self.implementation = .unimplemented
        self.callCount = .zero
        self.returnedValues.removeAll()
    }
}

// MARK: - Sendable

extension MockReturningNonParameterizedAsyncThrowingMethod: Sendable
    where ReturnValue: Sendable
{

    // MARK: Factories

    /// Creates a mock method, an async, throwing closure for invoking the mock
    /// method, and a closure for resetting the mock method, returning them
    /// in a labeled tuple.
    ///
    /// ```swift
    /// private let __users = MockReturningNonParameterizedAsyncThrowingMethod<
    ///     [User]
    /// >.makeMethod(
    ///     exposedMethodDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_users"
    ///     )
    /// )
    ///
    /// public var _users: MockReturningNonParameterizedAsyncThrowingMethod<[User]> {
    ///     self.__users.method
    /// }
    ///
    /// public func users() async throws -> [User] {
    ///     try await self.__users.invoke()
    /// }
    /// ```
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    /// - Returns: A tuple containing a mock method, an async, throwing closure
    ///   for invoking the mock method, and a closure for resetting the mock
    ///   method.
    public static func makeMethod(
        exposedMethodDescription: MockImplementationDescription
    ) -> (
        method: MockReturningNonParameterizedAsyncThrowingMethod,
        invoke: @Sendable () async throws -> ReturnValue,
        reset: @Sendable () -> Void
    ) {
        let method = MockReturningNonParameterizedAsyncThrowingMethod(
            exposedMethodDescription: exposedMethodDescription
        )

        return (
            method: method,
            invoke: method.invoke,
            reset: method.reset
        )
    }
}
