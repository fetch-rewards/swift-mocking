//
//  MockReadOnlyAsyncThrowingSubscript.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Locking

/// A mock subscript that contains implementation details and invocation records
/// for a read-only, async, throwing subscript.
public final class MockReadOnlyAsyncThrowingSubscript<Arguments, Value> {

    // MARK: Properties

    /// The subscript's getter.
    @Locked(.unchecked)
    public var getter: MockSubscriptAsyncThrowingGetter<Arguments, Value>

    // MARK: Initializers

    /// Creates a mock subscript that contains implementation details and
    /// invocation records for a read-only, async, throwing subscript.
    ///
    /// - Parameter exposedSubscriptDescription: The description of the mock's
    ///   exposed subscript.
    private init(exposedSubscriptDescription: MockImplementationDescription) {
        self.getter = MockSubscriptAsyncThrowingGetter(
            exposedSubscriptDescription: exposedSubscriptDescription
        )
    }

    // MARK: Factories

    /// Creates a mock subscript, an async, throwing closure for invoking the
    /// mock subscript's getter, and a closure for resetting the mock subscript's
    /// getter, returning them in a labeled tuple.
    ///
    /// - Parameter exposedSubscriptDescription: The description of the mock's
    ///   exposed subscript.
    /// - Returns: A tuple containing a mock subscript, an async, throwing
    ///   closure for invoking the mock subscript's getter, and a closure for
    ///   resetting the mock subscript's getter.
    public static func makeSubscript(
        exposedSubscriptDescription: MockImplementationDescription
    ) -> (
        subscript: MockReadOnlyAsyncThrowingSubscript,
        get: (Arguments) async throws -> Value,
        reset: () -> Void
    ) {
        let mock = MockReadOnlyAsyncThrowingSubscript(
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

extension MockReadOnlyAsyncThrowingSubscript: Sendable where Arguments: Sendable, Value: Sendable {

    // MARK: Factories

    /// Creates a mock subscript, an async, throwing closure for invoking the
    /// mock subscript's getter, and a closure for resetting the mock subscript's
    /// getter, returning them in a labeled tuple.
    ///
    /// - Parameter exposedSubscriptDescription: The description of the mock's
    ///   exposed subscript.
    /// - Returns: A tuple containing a mock subscript, an async, throwing
    ///   closure for invoking the mock subscript's getter, and a closure for
    ///   resetting the mock subscript's getter.
    public static func makeSubscript(
        exposedSubscriptDescription: MockImplementationDescription
    ) -> (
        subscript: MockReadOnlyAsyncThrowingSubscript,
        get: @Sendable (Arguments) async throws -> Value,
        reset: @Sendable () -> Void
    ) {
        let mock = MockReadOnlyAsyncThrowingSubscript(
            exposedSubscriptDescription: exposedSubscriptDescription
        )

        return (
            subscript: mock,
            get: mock.getter.get,
            reset: mock.reset
        )
    }
}
