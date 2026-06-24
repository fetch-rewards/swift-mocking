//
//  MockReturningNonParameterizedMethod.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Locking

/// A mock method that contains implementation details and invocation records
/// for a returning, non-parameterized method.
public final class MockReturningNonParameterizedMethod<ReturnValue> {

    // MARK: State

    /// All invocation records; grouped so reads and writes across them are atomic.
    private struct State {
        var callCount: Int = .zero
        var returnedValues: [ReturnValue] = []
    }

    // MARK: Properties

    /// Single lock for all invocation state; prevents torn reads between state properties.
    private let _state = OSAllocatedUnfairLock(uncheckedState: State())

    /// The method's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the method has been called.
    public var callCount: Int {
        self._state.withLockUnchecked { state in
            state.callCount
        }
    }

    /// All the values that have been returned by the method.
    public var returnedValues: [ReturnValue] {
        self._state.withLockUnchecked { state in
            state.returnedValues
        }
    }

    /// The last value returned by the method.
    public var lastReturnedValue: ReturnValue? {
        self._state.withLockUnchecked { state in
            state.returnedValues.last
        }
    }

    /// The description of the mock's exposed method.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed method needs an implementation for the test to
    /// succeed.
    private let exposedMethodDescription: MockImplementationDescription

    // MARK: Initializers

    /// Creates a mock method that contains implementation details and
    /// invocation records for a returning, non-parameterized method.
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    private init(exposedMethodDescription: MockImplementationDescription) {
        self.exposedMethodDescription = exposedMethodDescription
    }

    // MARK: Factories

    /// Creates a mock method, a closure for invoking the mock method, and a
    /// closure for resetting the mock method, returning them in a labeled
    /// tuple.
    ///
    /// ```swift
    /// private let __users = MockReturningNonParameterizedMethod<[User]>.makeMethod(
    ///     exposedMethodDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_users"
    ///     )
    /// )
    ///
    /// public var _users: MockReturningNonParameterizedMethod<[User]> {
    ///     self.__users.method
    /// }
    ///
    /// public func users() -> [User] {
    ///     self.__users.invoke()
    /// }
    /// ```
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    /// - Returns: A tuple containing a mock method, a closure for invoking the
    ///   mock method, and a closure for resetting the mock method.
    public static func makeMethod(
        exposedMethodDescription: MockImplementationDescription
    ) -> (
        method: MockReturningNonParameterizedMethod,
        invoke: () -> ReturnValue,
        reset: () -> Void
    ) {
        let method = MockReturningNonParameterizedMethod(
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
    /// - Returns: A value, if ``implementation-swift.property`` returns a
    ///   value.
    private func invoke() -> ReturnValue {
        guard let returnValue = self.implementation() else {
            fatalError("Unimplemented: \(self.exposedMethodDescription)")
        }

        self._state.withLockUnchecked { state in
            state.callCount += 1
            state.returnedValues.append(returnValue)
        }

        return returnValue
    }

    // MARK: Reset

    /// Resets the method's implementation and invocation records.
    private func reset() {
        self._implementation.withLockUnchecked { implementation in
            implementation = .unimplemented
        }
        self._state.withLockUnchecked { state in
            state.callCount = .zero
            state.returnedValues.removeAll()
        }
    }
}

// MARK: - Sendable

extension MockReturningNonParameterizedMethod: Sendable
    where ReturnValue: Sendable
{

    // MARK: Factories

    /// Creates a mock method, a closure for invoking the mock method, and a
    /// closure for resetting the mock method, returning them in a labeled
    /// tuple.
    ///
    /// ```swift
    /// private let __users = MockReturningNonParameterizedMethod<[User]>.makeMethod(
    ///     exposedMethodDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_users"
    ///     )
    /// )
    ///
    /// public var _users: MockReturningNonParameterizedMethod<[User]> {
    ///     self.__users.method
    /// }
    ///
    /// public func users() -> [User] {
    ///     self.__users.invoke()
    /// }
    /// ```
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    /// - Returns: A tuple containing a mock method, a closure for invoking the
    ///   mock method, and a closure for resetting the mock method.
    public static func makeMethod(
        exposedMethodDescription: MockImplementationDescription
    ) -> (
        method: MockReturningNonParameterizedMethod,
        invoke: @Sendable () -> ReturnValue,
        reset: @Sendable () -> Void
    ) {
        let method = MockReturningNonParameterizedMethod(
            exposedMethodDescription: exposedMethodDescription
        )

        return (
            method: method,
            invoke: method.invoke,
            reset: method.reset
        )
    }
}
