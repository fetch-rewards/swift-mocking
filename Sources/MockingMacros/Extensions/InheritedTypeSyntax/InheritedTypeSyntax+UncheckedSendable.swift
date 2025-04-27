//
//  InheritedTypeSyntax+UncheckedSendable.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax

extension InheritedTypeSyntax {
    
    /// An `InheritedTypeSyntax` representing unchecked sendable conformance
    /// with a trailing comma.
    ///
    /// ```swift
    /// // Represents
    /// @unchecked Sendable,
    /// ```
    static let uncheckedSendable = InheritedTypeSyntax(
        type: AttributedTypeSyntax(
            specifiers: [],
            attributes: AttributeListSyntax {
                AttributeSyntax(
                    attributeName: IdentifierTypeSyntax(
                        name: "unchecked"
                    )
                )
            },
            baseType: IdentifierTypeSyntax(name: "Sendable")
        ),
        trailingComma: .commaToken()
    )
}
