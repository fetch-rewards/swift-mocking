//
//  MockVoidNonParameterizedMethod.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
import Locking

/// A mock method that contains implementation details and invocation records
/// for a void, non-parameterized method.
public final class MockVoidNonParameterizedMethod: Sendable {

    // MARK: Properties

    /// The method's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the method has been called.
    @Locked(.checked)
    public private(set) var callCount: Int = .zero

    // MARK: Initializers

    /// Creates a mock method that contains implementation details and
    /// invocation records for a void, non-parameterized method.
    private init() {}

    // MARK: Factories

    /// Creates a mock method, a closure for invoking the mock method, and a
    /// closure for resetting the mock method, returning them in a labeled
    /// tuple.
    ///
    /// ```swift
    /// private let __logOut = MockVoidNonParameterizedMethod.makeMethod()
    ///
    /// public var _logOut: MockVoidNonParameterizedMethod {
    ///     self.__logOut.method
    /// }
    ///
    /// public func logOut() {
    ///     self.__logOut.invoke()
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a mock method, a closure for invoking the
    ///   mock method, and a closure for resetting the mock method.
    public static func makeMethod(
    ) -> (
        method: MockVoidNonParameterizedMethod,
        invoke: @Sendable () -> Void,
        reset: @Sendable () -> Void
    ) {
        let method = MockVoidNonParameterizedMethod()

        return (
            method: method,
            invoke: method.invoke,
            reset: method.reset
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes
    /// ``implementation-swift.property``.
    private func invoke() {
        self._callCount.withLock { callCount in
            callCount += 1
        }
        self.implementation()
    }

    // MARK: Reset

    /// Resets the method's implementation and invocation records.
    private func reset() {
        self._implementation.withLockUnchecked { implementation in
            implementation = .unimplemented
        }
        self._callCount.withLock { callCount in
            callCount = .zero
        }
    }
}
