//
//  MockVoidNonParameterizedThrowingMethod.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
import Synchronization

/// A mock method that contains implementation details and invocation records
/// for a void, non-parameterized, throwing method.
public final class MockVoidNonParameterizedThrowingMethod: Sendable {

    // MARK: Properties

    /// The method's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the method has been called.
    @Locked(.unchecked)
    public private(set) var callCount: Int = .zero

    /// All the errors that have been thrown by the method.
    @Locked(.unchecked)
    public private(set) var thrownErrors: [any Error] = []

    /// The last error thrown by the method.
    public var lastThrownError: (any Error)? {
        self.thrownErrors.last
    }

    // MARK: Initializers

    /// Creates a mock method that contains implementation details and
    /// invocation records for a void, non-parameterized, throwing method.
    private init() {}

    // MARK: Factories

    /// Creates a mock method, a throwing closure for invoking the mock method,
    /// and a closure for resetting the mock method, returning them in a labeled
    /// tuple.
    ///
    /// ```swift
    /// private let __logOut = MockVoidNonParameterizedThrowingMethod.makeMethod()
    ///
    /// public var _logOut: MockVoidNonParameterizedThrowingMethod {
    ///     self.__logOut.method
    /// }
    ///
    /// public func logOut() throws {
    ///     try self.__logOut.invoke()
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a mock method, a throwing closure for
    ///   invoking the mock method, and a closure for resetting the mock method.
    public static func makeMethod(
    ) -> (
        method: MockVoidNonParameterizedThrowingMethod,
        invoke: @Sendable () throws -> Void,
        reset: @Sendable () -> Void
    ) {
        let method = MockVoidNonParameterizedThrowingMethod()

        return (
            method: method,
            invoke: method.invoke,
            reset: method.reset
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes
    /// ``implementation-swift.property``.
    private func invoke() throws {
        self.callCount += 1

        do {
            try self.implementation()
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
        self.thrownErrors.removeAll()
    }
}
