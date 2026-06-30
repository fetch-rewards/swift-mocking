//
//  LabeledExprSyntax+MacroArgumentSyntax.swift
//
//  Copyright © 2026 Fetch.
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

    /// Returns the argument syntax for a factory call with the provided label,
    /// factory name, and inner arguments.
    ///
    /// ```swift
    /// argument(label: "subscriptType", name: "readOnly", arguments: [...])
    /// // Represents
    /// subscriptType: .readOnly(...)
    /// ```
    static func macroArgumentSyntax(
        label: String,
        name: String,
        arguments: [LabeledExprSyntax]
    ) -> LabeledExprSyntax {
        LabeledExprSyntax(
            label: .identifier(label),
            colon: .colonToken(),
            expression: FunctionCallExprSyntax(
                calledExpression: MemberAccessExprSyntax(
                    period: .periodToken(),
                    declName: DeclReferenceExprSyntax(baseName: .identifier(name))
                ),
                leftParen: .leftParenToken(),
                arguments: LabeledExprListSyntax(arguments),
                rightParen: .rightParenToken()
            )
        )
    }
}
