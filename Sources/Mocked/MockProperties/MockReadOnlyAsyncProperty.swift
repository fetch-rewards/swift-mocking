//
//  MockReadOnlyAsyncProperty.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's read-only,
/// async property.
public final class MockReadOnlyAsyncProperty<Value> {

    // MARK: Properties

    /// The property's getter.
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

    /// Creates a property and an async closure for invoking the property's
    /// getter, returning them in a labeled tuple.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a property and an async closure for
    ///   invoking the property's getter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadOnlyAsyncProperty,
        get: () async -> Value
    ) {
        let property = MockReadOnlyAsyncProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: { await property.getter.get() }
        )
    }
}
