//
//  LabeledExprSyntax+MacroArgumentSyntax.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax

extension LabeledExprSyntax {

    /// Returns the argument syntax for the provided label, base, and name.
    ///
    /// ```swift
    /// argument(label: "enumArgument", base: "SomeEnum", name: "someCase")
    /// // Represents
    /// enumArgument: SomeEnum.someCase
    /// ```
    static func macroArgumentSyntax(
        label: String,
        base: String?,
        name: String
    ) -> LabeledExprSyntax {
        LabeledExprSyntax(
            label: .identifier(label),
            colon: .colonToken(),
            expression: MemberAccessExprSyntax(
                base: base.map {
                    DeclReferenceExprSyntax(baseName: .identifier($0))
                },
                period: .periodToken(),
                declName: DeclReferenceExprSyntax(baseName: .identifier(name))
            )
        )
    }
}
