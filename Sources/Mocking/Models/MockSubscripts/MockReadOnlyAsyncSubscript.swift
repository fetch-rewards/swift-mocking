//
//  MockReadOnlyAsyncSubscript.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Locking

/// A mock subscript that contains implementation details and invocation records
/// for a read-only, async subscript.
public final class MockReadOnlyAsyncSubscript<Arguments, Value> {

    // MARK: Properties

    /// The subscript's getter.
    @Locked(.unchecked)
    public var getter: MockSubscriptAsyncGetter<Arguments, Value>

    // MARK: Initializers

    /// Creates a mock subscript that contains implementation details and
    /// invocation records for a read-only, async subscript.
    ///
    /// - Parameter exposedSubscriptDescription: The description of the mock's
    ///   exposed subscript.
    private init(exposedSubscriptDescription: MockImplementationDescription) {
        self.getter = MockSubscriptAsyncGetter(
            exposedSubscriptDescription: exposedSubscriptDescription
        )
    }

    // MARK: Factories

    /// Creates a mock subscript, an async closure for invoking the mock
    /// subscript's getter, and a closure for resetting the mock subscript's
    /// getter, returning them in a labeled tuple.
    ///
    /// - Parameter exposedSubscriptDescription: The description of the mock's
    ///   exposed subscript.
    /// - Returns: A tuple containing a mock subscript, an async closure for
    ///   invoking the mock subscript's getter, and a closure for resetting the
    ///   mock subscript's getter.
    public static func makeSubscript(
        exposedSubscriptDescription: MockImplementationDescription
    ) -> (
        subscript: MockReadOnlyAsyncSubscript,
        get: (Arguments) async -> Value,
        reset: () -> Void
    ) {
        let mock = MockReadOnlyAsyncSubscript(
            exposedSubscriptDescription: exposedSubscriptDescription
        )

        return (
            subscript: mock,
            get: mock.getter.get,
            reset: mock.reset
        )
    }

    // MARK: Reset

    /// Resets the subscript's getter.
    private func reset() {
        self.getter.reset()
    }
}

// MARK: - Sendable

extension MockReadOnlyAsyncSubscript: Sendable where Arguments: Sendable, Value: Sendable {

    // MARK: Factories

    /// Creates a mock subscript, an async closure for invoking the mock
    /// subscript's getter, and a closure for resetting the mock subscript's
    /// getter, returning them in a labeled tuple.
    ///
    /// - Parameter exposedSubscriptDescription: The description of the mock's
    ///   exposed subscript.
    /// - Returns: A tuple containing a mock subscript, an async closure for
    ///   invoking the mock subscript's getter, and a closure for resetting the
    ///   mock subscript's getter.
    public static func makeSubscript(
        exposedSubscriptDescription: MockImplementationDescription
    ) -> (
        subscript: MockReadOnlyAsyncSubscript,
        get: @Sendable (Arguments) async -> Value,
        reset: @Sendable () -> Void
    ) {
        let mock = MockReadOnlyAsyncSubscript(
            exposedSubscriptDescription: exposedSubscriptDescription
        )

        return (
            subscript: mock,
            get: mock.getter.get,
            reset: mock.reset
        )
    }
}
