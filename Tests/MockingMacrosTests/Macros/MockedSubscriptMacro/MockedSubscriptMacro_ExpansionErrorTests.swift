//
//  MockedSubscriptMacro_ExpansionErrorTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockingMacros

struct MockedSubscriptMacro_ExpansionErrorTests {

    // MARK: Expansion Error Tests

    @Test
    func appliedToNonSubscriptDeclaration() {
        assertMockedSubscript(
            """
            func fetch(key: String) -> String?
            """,
            ofType: ".readOnly",
            named: "fetchKey",
            generates: """
            func fetch(key: String) -> String?
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@_MockedSubscript can only be applied to subscript declarations.",
                    line: 1,
                    column: 1,
                    severity: .error
                ),
            ]
        )
    }
}
#endif
