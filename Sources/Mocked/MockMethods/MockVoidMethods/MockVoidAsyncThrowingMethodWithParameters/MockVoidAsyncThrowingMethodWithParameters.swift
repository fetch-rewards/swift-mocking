//
//  MockVoidAsyncThrowingMethodWithParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Locked

/// The implementation details and invocation records for a mock's void, async,
/// throwing method with parameters.
public final class MockVoidAsyncThrowingMethodWithParameters<Arguments> {

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

    /// All the errors that have been thrown by the method.
    @Locked(.unchecked)
    public private(set) var thrownErrors: [any Error] = []

    /// The last error thrown by the method.
    public var lastThrownError: (any Error)? {
        self.thrownErrors.last
    }

    // MARK: Initializers

    /// Creates a void, async, throwing method with parameters.
    private init() {}

    // MARK: Factories

    /// Creates a method, an async, throwing closure for invoking the method,
    /// and a closure for resetting the method, returning them in a labeled
    /// tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidAsyncThrowingMethodWithParameters<(String, String)>.makeMethod()
    ///
    /// public var _logIn: MockVoidAsyncThrowingMethodWithParameters<(String, String)> {
    ///     self.__logIn.method
    /// }
    ///
    /// public func logIn(username: String, password: String) async throws {
    ///     try await self.__logIn.invoke((username, password))
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a method, an async, throwing closure for
    ///   invoking the method, and a closure for resetting the method.
    public static func makeMethod(
    ) -> (
        method: MockVoidAsyncThrowingMethodWithParameters,
        invoke: (Arguments) async throws -> Void,
        reset: () -> Void
    ) {
        let method = MockVoidAsyncThrowingMethodWithParameters()

        return (
            method: method,
            invoke: { try await method.invoke($0) },
            reset: { method.reset() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes ``implementation``.
    ///
    /// - Parameter arguments: The arguments with which the method is being
    ///   invoked.
    /// - Throws: An error, if ``implementation`` is
    ///   ``Implementation-swift.enum/uncheckedThrows(_:)-swift.enum.case`` or
    ///   ``Implementation-swift.enum/uncheckedThrows(_:)-swift.type.method``.
    private func invoke(_ arguments: Arguments) async throws {
        self.callCount += 1
        self.invocations.append(arguments)

        do {
            try await self.implementation(arguments: arguments)
        } catch {
            self.thrownErrors.append(error)
            throw error
        }
    }

    // MARK: Reset

    /// Resets the method's implementation and invocation records.
    private func reset() {
        self.implementation = .unimplemented
        self.callCount = .zero
        self.invocations.removeAll()
        self.thrownErrors.removeAll()
    }
}

// MARK: - Sendable

extension MockVoidAsyncThrowingMethodWithParameters: Sendable
where Arguments: Sendable {

    // MARK: Factories

    /// Creates a method, an async, throwing closure for invoking the method,
    /// and a closure for resetting the method, returning them in a labeled
    /// tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidAsyncThrowingMethodWithParameters<(String, String)>.makeMethod()
    ///
    /// public var _logIn: MockVoidAsyncThrowingMethodWithParameters<(String, String)> {
    ///     self.__logIn.method
    /// }
    ///
    /// public func logIn(username: String, password: String) async throws {
    ///     try await self.__logIn.invoke((username, password))
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a method, an async, throwing closure for
    ///   invoking the method, and a closure for resetting the method.
    public static func makeMethod(
    ) -> (
        method: MockVoidAsyncThrowingMethodWithParameters,
        invoke: @Sendable (Arguments) async throws -> Void,
        reset: @Sendable () -> Void
    ) {
        let method = MockVoidAsyncThrowingMethodWithParameters()

        return (
            method: method,
            invoke: { try await method.invoke($0) },
            reset: { method.reset() }
        )
    }
}
