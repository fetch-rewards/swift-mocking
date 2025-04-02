//
//  MockReadOnlyAsyncThrowingProperty.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Locked

/// A mock property that contains implementation details and invocation records
/// for a read-only, async, throwing property.
public final class MockReadOnlyAsyncThrowingProperty<Value> {

    // MARK: Properties

    /// The property's getter.
    @Locked(.unchecked)
    public var getter: MockPropertyAsyncThrowingGetter<Value>

    // MARK: Initializers

    /// Creates a mock property that contains implementation details and
    /// invocation records for a read-only, async, throwing property.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    private init(exposedPropertyDescription: MockImplementationDescription) {
        self.getter = MockPropertyAsyncThrowingGetter(
            exposedPropertyDescription: exposedPropertyDescription
        )
    }

    // MARK: Factories

    /// Creates a mock property, an async, throwing closure for invoking the
    /// mock property's getter, and a closure for resetting the mock property's
    /// getter, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __user = MockReadOnlyAsyncThrowingProperty<User>.makeProperty(
    ///     exposedPropertyDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReadOnlyAsyncThrowingProperty<User> {
    ///     self.__user.property
    /// }
    ///
    /// public var user: User {
    ///     get async throws {
    ///         try await self.__user.get()
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a mock property, an async, throwing
    ///   closure for invoking the mock property's getter, and a closure for
    ///   resetting the mock property's getter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadOnlyAsyncThrowingProperty,
        get: () async throws -> Value,
        reset: () -> Void
    ) {
        let property = MockReadOnlyAsyncThrowingProperty(
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

extension MockReadOnlyAsyncThrowingProperty: Sendable where Value: Sendable {

    // MARK: Factories

    /// Creates a mock property, an async, throwing closure for invoking the
    /// mock property's getter, and a closure for resetting the mock property's
    /// getter, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __user = MockReadOnlyAsyncThrowingProperty<User>.makeProperty(
    ///     exposedPropertyDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReadOnlyAsyncThrowingProperty<User> {
    ///     self.__user.property
    /// }
    ///
    /// public var user: User {
    ///     get async throws {
    ///         try await self.__user.get()
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a mock property, an async, throwing
    ///   closure for invoking the mock property's getter, and a closure for
    ///   resetting the mock property's getter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadOnlyAsyncThrowingProperty,
        get: @Sendable () async throws -> Value,
        reset: @Sendable () -> Void
    ) {
        let property = MockReadOnlyAsyncThrowingProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: property.getter.get,
            reset: property.reset
        )
    }
}
