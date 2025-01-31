//
//  MockedMembersMacro+MockMethodNameComponent.swift
//  MockedMacros
//
//  Created by Gray Campbell on 1/26/25.
//

import SwiftSyntax

extension MockedMembersMacro {

    /// A mock method name component.
    struct MockMethodNameComponent: Identifiable {

        // MARK: Properties

        /// The component's ID.
        let id: ID

        /// The order of the component in the mock method's full name.
        let order: Int

        /// The component's value.
        let value: String

        // MARK: Initializers

        /// Creates a mock method name component.
        ///
        /// - Parameters:
        ///   - id: The component's ID.
        ///   - order: The order of the component in the mock method's full
        ///     name.
        ///   - value: The component's value.
        init(
            id: ID,
            order: Int,
            value: String
        ) {
            self.id = id
            self.order = order
            self.value = value
        }
    }
}
