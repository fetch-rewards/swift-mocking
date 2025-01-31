//
//  MockedMembersMacro+MockMethodNameComponents.swift
//  MockedMacros
//
//  Created by Gray Campbell on 1/25/25.
//

import SwiftSyntax

extension MockedMembersMacro {

    /// A mock method's name components.
    struct MockMethodNameComponents {

        // MARK: Properties

        /// The name components in order of when they get added to the mock
        /// method's full name.
        private let components: [MockMethodNameComponent]

        // MARK: Initializers

        /// Creates name components from the provided `methodDeclaration`.
        ///
        /// - Parameter methodDeclaration: The method declaration from which to
        ///   parse name components.
        init(methodDeclaration: FunctionDeclSyntax) {
            let signature = methodDeclaration.signature
            let parameters = signature.parameterClause.parameters

            var components: [MockMethodNameComponent] = []

            components.append(.name(from: methodDeclaration))

            for (index, parameter) in parameters.enumerated() {
                components.append(.name(from: parameter, at: index))
            }

            if let returnType = MockMethodNameComponent.returnType(from: signature) {
                components.append(returnType)
            }

            for (index, parameter) in parameters.enumerated() {
                components.append(.type(from: parameter, at: index))
            }

            self.components = components
        }
    }
}
