//
//  MockReadOnlySubscript.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Locking

/// A mock subscript that contains implementation details and invocation records
/// for a read-only subscript.
public final class MockReadOnlySubscript<Key, Value> {

    // MARK: Properties

    /// The subscript's getter.
    @Locked(.unchecked)
    public var getter: MockSubscriptGetter<Key, Value>

    // MARK: Initializers

    /// Creates a mock subscript that contains implementation details and
    /// invocation records for a read-only subscript.
    ///
    /// - Parameter exposedSubscriptDescription: The description of the mock's
    ///   exposed subscript.
    private init(exposedSubscriptDescription: MockImplementationDescription) {
        self.getter = MockSubscriptGetter(
            exposedSubscriptDescription: exposedSubscriptDescription
        )
    }

    // MARK: Factories

    /// Creates a mock subscript, a closure for invoking the mock subscript's
    /// getter, and a closure for resetting the mock subscript's getter,
    /// returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __subscript = MockReadOnlySubscript<String, String?>.makeSubscript(
    ///     exposedSubscriptDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_subscript"
    ///     )
    /// )
    ///
    /// public var _subscript: MockReadOnlySubscript<String, String?> {
    ///     self.__subscript.`subscript`
    /// }
    ///
    /// public subscript(key: String) -> String? {
    ///     self.__subscript.get(key)
    /// }
    /// ```
    ///
    /// - Parameter exposedSubscriptDescription: The description of the mock's
    ///   exposed subscript.
    /// - Returns: A tuple containing a mock subscript, a closure for invoking
    ///   the mock subscript's getter, and a closure for resetting the mock
    ///   subscript's getter.
    public static func makeSubscript(
        exposedSubscriptDescription: MockImplementationDescription
    ) -> (
        subscript: MockReadOnlySubscript,
        get: (Key) -> Value,
        reset: () -> Void
    ) {
        let mock = MockReadOnlySubscript(
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

extension MockReadOnlySubscript: Sendable where Key: Sendable, Value: Sendable {

    // MARK: Factories

    /// Creates a mock subscript, a closure for invoking the mock subscript's
    /// getter, and a closure for resetting the mock subscript's getter,
    /// returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __subscript = MockReadOnlySubscript<String, String?>.makeSubscript(
    ///     exposedSubscriptDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_subscript"
    ///     )
    /// )
    ///
    /// public var _subscript: MockReadOnlySubscript<String, String?> {
    ///     self.__subscript.`subscript`
    /// }
    ///
    /// public subscript(key: String) -> String? {
    ///     self.__subscript.get(key)
    /// }
    /// ```
    ///
    /// - Parameter exposedSubscriptDescription: The description of the mock's
    ///   exposed subscript.
    /// - Returns: A tuple containing a mock subscript, a closure for invoking
    ///   the mock subscript's getter, and a closure for resetting the mock
    ///   subscript's getter.
    public static func makeSubscript(
        exposedSubscriptDescription: MockImplementationDescription
    ) -> (
        subscript: MockReadOnlySubscript,
        get: @Sendable (Key) -> Value,
        reset: @Sendable () -> Void
    ) {
        let mock = MockReadOnlySubscript(
            exposedSubscriptDescription: exposedSubscriptDescription
        )

        return (
            subscript: mock,
            get: mock.getter.get,
            reset: mock.reset
        )
    }
}
