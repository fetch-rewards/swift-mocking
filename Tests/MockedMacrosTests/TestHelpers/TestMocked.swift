//
//  TestMocked.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

// Macro implementations build for the host, so the corresponding module is not
// available when cross-compiling. Cross-compiled tests may still make use of
// the macro itself in end-to-end tests.
#if canImport(MockedMacros)
import MockedMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import SwiftSyntaxSugar

func testMocked(
    _ test: (InterfaceConfiguration, MockConfiguration) throws -> Void
) rethrows {
    for accessLevel in AccessLevelSyntax.allCases {
        try test(
            InterfaceConfiguration(accessLevel: accessLevel),
            MockConfiguration(interfaceAccessLevel: accessLevel)
        )
    }
}

func assertMocked(
    _ interface: String,
    generates mock: String,
    diagnostics: [DiagnosticSpec] = [],
    file: StaticString = #filePath,
    line: UInt = #line
) {
    assertMacroExpansion(
        """
        @Mocked
        \(interface)
        """,
        expandedSource: """
            \(interface)

            \(mock)
            """,
        diagnostics: diagnostics,
        macros: ["Mocked": MockedMacro.self],
        file: file,
        line: line
    )
}
#endif
