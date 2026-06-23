//
//  MockVoidNonParameterizedAsyncThrowingMethod.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Locking

/// A mock method that contains implementation details and invocation records
/// for a void, non-parameterized, async, throwing method.
public final class MockVoidNonParameterizedAsyncThrowingMethod: Sendable {

    // MARK: State

    private struct State {
        var callCount: Int = .zero
        var thrownErrors: [any Error] = []
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

    /// All the errors that have been thrown by the method.
    public var thrownErrors: [any Error] {
        self._state.withLockUnchecked { state in
            state.thrownErrors
        }
    }

    /// The last error thrown by the method.
    public var lastThrownError: (any Error)? {
        self.thrownErrors.last
    }

    // MARK: Initializers

    /// Creates a mock method that contains implementation details and
    /// invocation records for a void, non-parameterized, async, throwing
    /// method.
    private init() {}

    // MARK: Factories

    /// Creates a mock method, an async, throwing closure for invoking the
    /// mock method, and a closure for resetting the mock method, returning them
    /// in a labeled tuple.
    ///
    /// ```swift
    /// private let __logOut = MockVoidNonParameterizedAsyncThrowingMethod.makeMethod()
    ///
    /// public var _logOut: MockVoidNonParameterizedAsyncThrowingMethod {
    ///     self.__logOut.method
    /// }
    ///
    /// public func logOut() async throws {
    ///     try await self.__logOut.invoke()
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a mock method, an async, throwing closure
    ///   for invoking the mock method, and a closure for resetting the mock
    ///   method.
    public static func makeMethod(
    ) -> (
        method: MockVoidNonParameterizedAsyncThrowingMethod,
        invoke: @Sendable () async throws -> Void,
        reset: @Sendable () -> Void
    ) {
        let method = MockVoidNonParameterizedAsyncThrowingMethod()

        return (
            method: method,
            invoke: method.invoke,
            reset: method.reset
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes
    /// ``implementation-swift.property``.
    private func invoke() async throws {
        var caughtError: (any Error)?

        do {
            try await self.implementation()
        } catch {
            caughtError = error
        }

        self._state.withLockUnchecked { state in
            state.callCount += 1

            if let caughtError {
                state.thrownErrors.append(caughtError)
            }
        }

        if let caughtError {
            throw caughtError
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
            state.thrownErrors.removeAll()
        }
    }
}
