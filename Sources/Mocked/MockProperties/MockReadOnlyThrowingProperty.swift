//
//  MockReadOnlyThrowingProperty.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's read-only,
/// throwing property.
public final class MockReadOnlyThrowingProperty<Value> {

    // MARK: Properties

    /// The property's getter.
    public var getter: MockPropertyThrowingGetter<Value>

    // MARK: Initializers

    /// Creates a read-only, throwing property.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    private init(exposedPropertyDescription: MockImplementationDescription) {
        self.getter = MockPropertyThrowingGetter(
            exposedPropertyDescription: exposedPropertyDescription
        )
    }

    // MARK: Factories

    /// Creates a property and a throwing closure for invoking the property's
    /// getter, returning them in a labeled tuple.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a property and a throwing closure for
    ///   invoking the property's getter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadOnlyThrowingProperty,
        get: () throws -> Value
    ) {
        let property = MockReadOnlyThrowingProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: { try property.getter.get() }
        )
    }
}
