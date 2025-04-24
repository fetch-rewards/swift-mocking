//
//  MockVoidParameterizedAsyncMethod.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
import Synchronization

/// A mock method that contains implementation details and invocation records
/// for a void, parameterized, async method.
public final class MockVoidParameterizedAsyncMethod<
    Implementation: MockVoidParameterizedAsyncMethodImplementation
> {

    // MARK: Typealiases

    /// The method's arguments type.
    public typealias Arguments = Implementation.Arguments

    /// The method's closure type.
    public typealias Closure = Implementation.Closure

    // MARK: Properties

    /// The method's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the method has been called.
    @Locked(.unchecked)
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the method has been invoked.
    @Locked(.unchecked)
    public private(set) var invocations: [Arguments] = []

    /// The last arguments with which the method has been invoked.
    public var lastInvocation: Arguments? {
        self.invocations.last
    }

    // MARK: Initializers

    /// Creates a mock method that contains implementation details and
    /// invocation records for a void, parameterized, async method.
    private init() {}

    // MARK: Factories

    /// Creates a mock method, a closure for recording an invocation's input, a
    /// closure for retrieving the mock method's implementation as a closure,
    /// and a closure for resetting the mock method, returning them in a labeled
    /// tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidParameterizedAsyncMethod<
    ///     LogInImplementation
    /// >.makeMethod()
    ///
    /// public var _logIn: MockVoidParameterizedAsyncMethod<
    ///     LogInImplementation
    /// > {
    ///     self.__logIn.method
    /// }
    ///
    /// public func logIn(username: String, password: String) async {
    ///     self.__logIn.recordInput((username, password))
    ///
    ///     let invoke = self.__logIn.closure()
    ///
    ///     await invoke?(username, password)
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a mock method, a closure for recording an
    ///   invocation's input, a closure for retrieving the mock method's
    ///   implementation as a closure, and a closure for resetting the mock
    ///   method.
    public static func makeMethod(
    ) -> (
        method: MockVoidParameterizedAsyncMethod,
        recordInput: (Arguments) -> Void,
        closure: () -> Closure?,
        reset: () -> Void
    ) {
        let method = MockVoidParameterizedAsyncMethod()

        return (
            method: method,
            recordInput: method.recordInput,
            closure: method.closure,
            reset: method.reset
        )
    }

    // MARK: Record

    /// Records the input of an invocation of the method.
    ///
    /// - Parameter arguments: The arguments with which the method is being
    ///   invoked.
    private func recordInput(arguments: Arguments) {
        self.callCount += 1
        self.invocations.append(arguments)
    }

    /// Returns the method's implementation as a closure, or `nil` if
    /// unimplemented.
    ///
    /// - Returns: The method's implementation as a closure, or `nil` if
    ///   unimplemented.
    private func closure() -> Closure? {
        self.implementation._closure
    }

    // MARK: Reset

    /// Resets the method's implementation and invocation records.
    private func reset() {
        self.implementation = .unimplemented
        self.callCount = .zero
        self.invocations.removeAll()
    }
}

// MARK: - Sendable

extension MockVoidParameterizedAsyncMethod: Sendable where Arguments: Sendable {

    // MARK: Factories

    /// Creates a mock method, a closure for recording an invocation's input, a
    /// closure for retrieving the mock method's implementation as a closure,
    /// and a closure for resetting the mock method, returning them in a labeled
    /// tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidParameterizedAsyncMethod<
    ///     LogInImplementation
    /// >.makeMethod()
    ///
    /// public var _logIn: MockVoidParameterizedAsyncMethod<
    ///     LogInImplementation
    /// > {
    ///     self.__logIn.method
    /// }
    ///
    /// public func logIn(username: String, password: String) async {
    ///     self.__logIn.recordInput((username, password))
    ///
    ///     let invoke = self.__logIn.closure()
    ///
    ///     await invoke?(username, password)
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a mock method, a closure for recording an
    ///   invocation's input, a closure for retrieving the mock method's
    ///   implementation as a closure, and a closure for resetting the mock
    ///   method.
    public static func makeMethod(
    ) -> (
        method: MockVoidParameterizedAsyncMethod,
        recordInput: @Sendable (Arguments) -> Void,
        closure: @Sendable () -> Closure?,
        reset: @Sendable () -> Void
    ) {
        let method = MockVoidParameterizedAsyncMethod()

        return (
            method: method,
            recordInput: method.recordInput,
            closure: method.closure,
            reset: method.reset
        )
    }
}
