//
//  MockVoidParameterizedThrowingMethod.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Locking

/// A mock method that contains implementation details and invocation records
/// for a void, parameterized, throwing method.
public final class MockVoidParameterizedThrowingMethod<
    Implementation: MockVoidParameterizedThrowingMethodImplementation
> {

    // MARK: Typealiases

    /// The method's arguments type.
    public typealias Arguments = Implementation.Arguments

    /// The method's error type.
    public typealias Error = Implementation.Error

    /// The method's closure type.
    public typealias Closure = Implementation.Closure

    // MARK: State

    private struct State {
        var callCount: Int = .zero
        var invocations: [Arguments] = []
        var thrownErrors: [Error] = []
    }

    // MARK: Properties

    /// The method's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    private let _state = OSAllocatedUnfairLock(uncheckedState: State())

    /// The number of times the method has been called.
    public var callCount: Int {
        self._state.withLockUnchecked { state in
            state.callCount
        }
    }

    /// All the arguments with which the method has been invoked.
    public var invocations: [Arguments] {
        self._state.withLockUnchecked { state in
            state.invocations
        }
    }

    /// The last arguments with which the method has been invoked.
    public var lastInvocation: Arguments? {
        self.invocations.last
    }

    /// All the errors that have been thrown by the method.
    public var thrownErrors: [Error] {
        self._state.withLockUnchecked { state in
            state.thrownErrors
        }
    }

    /// The last error thrown by the method.
    public var lastThrownError: Error? {
        self.thrownErrors.last
    }

    // MARK: Initializers

    /// Creates a mock method that contains implementation details and
    /// invocation records for a void, parameterized, throwing method.
    private init() {}

    // MARK: Factories

    /// Creates a mock method, a closure for recording an invocation's input, a
    /// closure for retrieving the mock method's implementation as a closure, a
    /// closure for recording an invocation's output, and a closure for
    /// resetting the mock method, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidParameterizedThrowingMethod<
    ///     LogInImplementation
    /// >.makeMethod()
    ///
    /// public var _logIn: MockVoidParameterizedThrowingMethod<
    ///     LogInImplementation
    /// > {
    ///     self.__logIn.method
    /// }
    ///
    /// public func logIn(username: String, password: String) throws {
    ///     self.__logIn.recordInput((username, password))
    ///
    ///     let invoke = self.__logIn.closure()
    ///
    ///     do {
    ///         try invoke?(username, password)
    ///     } catch {
    ///         self.__logIn.recordOutput(error)
    ///         throw error
    ///     }
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a mock method, a closure for recording an
    ///   invocation's input, a closure for retrieving the mock method's
    ///   implementation as a closure, a closure for recording an invocation's
    ///   output, and a closure for resetting the mock method.
    public static func makeMethod(
    ) -> (
        method: MockVoidParameterizedThrowingMethod,
        recordInput: (Arguments) -> Void,
        closure: () -> Closure?,
        recordOutput: (Error) -> Void,
        reset: () -> Void
    ) {
        let method = MockVoidParameterizedThrowingMethod()

        return (
            method: method,
            recordInput: method.recordInput,
            closure: method.closure,
            recordOutput: method.recordOutput,
            reset: method.reset
        )
    }

    // MARK: Record

    /// Records the input of an invocation of the method.
    ///
    /// - Parameter arguments: The arguments with which the method is being
    ///   invoked.
    private func recordInput(arguments: Arguments) {
        self._state.withLockUnchecked { state in
            state.callCount += 1
            state.invocations.append(arguments)
        }
    }

    /// Returns the method's implementation as a closure, or `nil` if
    /// unimplemented.
    ///
    /// - Returns: The method's implementation as a closure, or `nil` if
    ///   unimplemented.
    private func closure() -> Closure? {
        self.implementation._closure
    }

    /// Records the output of an invocation of the method.
    ///
    /// - Parameter error: The error thrown by the method.
    private func recordOutput(error: Error) {
        self._state.withLockUnchecked { state in
            state.thrownErrors.append(error)
        }
    }

    // MARK: Reset

    /// Resets the method's implementation and invocation records.
    private func reset() {
        self._implementation.withLockUnchecked { implementation in
            implementation = .unimplemented
        }
        self._state.withLockUnchecked { state in
            state.callCount = .zero
            state.invocations.removeAll()
            state.thrownErrors.removeAll()
        }
    }
}

// MARK: - Sendable

extension MockVoidParameterizedThrowingMethod: Sendable
    where Arguments: Sendable, Implementation: Sendable
{

    // MARK: Factories

    /// Creates a mock method, a closure for recording an invocation's input, a
    /// closure for retrieving the mock method's implementation as a closure, a
    /// closure for recording an invocation's output, and a closure for
    /// resetting the mock method, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidParameterizedThrowingMethod<
    ///     LogInImplementation
    /// >.makeMethod()
    ///
    /// public var _logIn: MockVoidParameterizedThrowingMethod<
    ///     LogInImplementation
    /// > {
    ///     self.__logIn.method
    /// }
    ///
    /// public func logIn(username: String, password: String) throws {
    ///     self.__logIn.recordInput((username, password))
    ///
    ///     let invoke = self.__logIn.closure()
    ///
    ///     do {
    ///         try invoke?(username, password)
    ///     } catch {
    ///         self.__logIn.recordOutput(error)
    ///         throw error
    ///     }
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a mock method, a closure for recording an
    ///   invocation's input, a closure for retrieving the mock method's
    ///   implementation as a closure, a closure for recording an invocation's
    ///   output, and a closure for resetting the mock method.
    public static func makeMethod(
    ) -> (
        method: MockVoidParameterizedThrowingMethod,
        recordInput: @Sendable (Arguments) -> Void,
        closure: @Sendable () -> Closure?,
        recordOutput: @Sendable (Error) -> Void,
        reset: @Sendable () -> Void
    ) {
        let method = MockVoidParameterizedThrowingMethod()

        return (
            method: method,
            recordInput: method.recordInput,
            closure: method.closure,
            recordOutput: method.recordOutput,
            reset: method.reset
        )
    }
}
