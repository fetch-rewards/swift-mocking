//
//  MockMethodNameComponent.swift
//  MockedMacros
//
//  Created by Gray Campbell on 1/26/25.
//

import SwiftSyntax

/// A mock method name component.
struct MockMethodNameComponent: Identifiable {

    // MARK: Properties

    /// The component's ID.
    let id: ID

    /// The component's value.
    let value: String

    /// The index at which the component is inserted into the mock method's full
    /// name.
    let insertionIndex: Int

    // MARK: Initializers

    /// Creates a mock method name component.
    ///
    /// - Parameters:
    ///   - id: The component's ID.
    ///   - value: The component's value.
    ///   - insertionIndex: The index at which the component is inserted into
    ///     the mock method's full name.
    init(
        id: ID,
        value: String,
        insertionIndex: Int
    ) {
        self.id = id
        self.value = value
        self.insertionIndex = insertionIndex
    }
}
