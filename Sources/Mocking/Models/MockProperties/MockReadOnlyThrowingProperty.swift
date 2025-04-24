//
//  MockReadOnlyThrowingProperty.swift
//  Mocking
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Synchronization

/// A mock property that contains implementation details and invocation records
/// for a read-only, throwing property.
public final class MockReadOnlyThrowingProperty<Value> {

    // MARK: Properties

    /// The property's getter.
    @Locked(.unchecked)
    public var getter: MockPropertyThrowingGetter<Value>

    // MARK: Initializers

    /// Creates a mock property that contains implementation details and
    /// invocation records for a read-only, throwing property.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    private init(exposedPropertyDescription: MockImplementationDescription) {
        self.getter = MockPropertyThrowingGetter(
            exposedPropertyDescription: exposedPropertyDescription
        )
    }

    // MARK: Factories

    /// Creates a mock property, a throwing closure for invoking the mock
    /// property's getter, and a closure for resetting the mock property's
    /// getter, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __user = MockReadOnlyThrowingProperty<User>.makeProperty(
    ///     exposedPropertyDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReadOnlyThrowingProperty<User> {
    ///     self.__user.property
    /// }
    ///
    /// public var user: User {
    ///     get throws {
    ///         try self.__user.get()
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a mock property, a throwing closure for
    ///   invoking the mock property's getter, and a closure for resetting the
    ///   mock property's getter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadOnlyThrowingProperty,
        get: () throws -> Value,
        reset: () -> Void
    ) {
        let property = MockReadOnlyThrowingProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: property.getter.get,
            reset: property.reset
        )
    }

    // MARK: Reset

    /// Resets the property's getter.
    private func reset() {
        self.getter.reset()
    }
}

// MARK: - Sendable

extension MockReadOnlyThrowingProperty: Sendable where Value: Sendable {

    // MARK: Factories

    /// Creates a mock property, a throwing closure for invoking the mock
    /// property's getter, and a closure for resetting the mock property's
    /// getter, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __user = MockReadOnlyThrowingProperty<User>.makeProperty(
    ///     exposedPropertyDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReadOnlyThrowingProperty<User> {
    ///     self.__user.property
    /// }
    ///
    /// public var user: User {
    ///     get throws {
    ///         try self.__user.get()
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a mock property, a throwing closure for
    ///   invoking the mock property's getter, and a closure for resetting the
    ///   mock property's getter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadOnlyThrowingProperty,
        get: @Sendable () throws -> Value,
        reset: @Sendable () -> Void
    ) {
        let property = MockReadOnlyThrowingProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: property.getter.get,
            reset: property.reset
        )
    }
}
