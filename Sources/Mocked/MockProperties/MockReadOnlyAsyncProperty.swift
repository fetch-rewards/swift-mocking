//
//  MockReadOnlyAsyncProperty.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Locked

/// The implementation details and invocation records for a mock's read-only,
/// async property.
public final class MockReadOnlyAsyncProperty<Value> {

    // MARK: Properties

    /// The property's getter.
    @Locked(.unchecked)
    public var getter: MockPropertyAsyncGetter<Value>

    // MARK: Initializers

    /// Creates a read-only, async property.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    private init(exposedPropertyDescription: MockImplementationDescription) {
        self.getter = MockPropertyAsyncGetter(
            exposedPropertyDescription: exposedPropertyDescription
        )
    }

    // MARK: Factories

    /// Creates a property, an async closure for invoking the property's getter,
    /// and a closure for resetting the property's getter, returning them in a
    /// labeled tuple.
    ///
    /// ```swift
    /// private let __user = MockReadOnlyAsyncProperty<User>.makeProperty(
    ///     exposedPropertyDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReadOnlyAsyncProperty<User> {
    ///     self.__user.property
    /// }
    ///
    /// public var user: User {
    ///     get async {
    ///         await self.__user.get()
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a property, an async closure for invoking
    ///   the property's getter, and a closure for resetting the property's
    ///   getter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadOnlyAsyncProperty,
        get: () async -> Value,
        reset: () -> Void
    ) {
        let property = MockReadOnlyAsyncProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: { await property.getter.get() },
            reset: { property.reset() }
        )
    }

    // MARK: Reset

    /// Resets the property's getter.
    private func reset() {
        self.getter.reset()
    }
}

// MARK: - Sendable

extension MockReadOnlyAsyncProperty: Sendable
where Value: Sendable {

    // MARK: Factories

    /// Creates a property, an async closure for invoking the property's getter,
    /// and a closure for resetting the property's getter, returning them in a
    /// labeled tuple.
    ///
    /// ```swift
    /// private let __user = MockReadOnlyAsyncProperty<User>.makeProperty(
    ///     exposedPropertyDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReadOnlyAsyncProperty<User> {
    ///     self.__user.property
    /// }
    ///
    /// public var user: User {
    ///     get async {
    ///         await self.__user.get()
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a property, an async closure for invoking
    ///   the property's getter, and a closure for resetting the property's
    ///   getter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadOnlyAsyncProperty,
        get: @Sendable () async -> Value,
        reset: @Sendable () -> Void
    ) {
        let property = MockReadOnlyAsyncProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: { await property.getter.get() },
            reset: { property.reset() }
        )
    }
}
