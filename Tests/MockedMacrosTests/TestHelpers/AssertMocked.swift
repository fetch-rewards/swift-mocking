//
//  AssertMocked.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

// Macro implementations build for the host, so the corresponding module is not
// available when cross-compiling. Cross-compiled tests may still make use of
// the macro itself in end-to-end tests.
#if canImport(MockedMacros)
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import SwiftSyntaxSugar
import Testing
@testable import MockedMacros

let testConfigurations = AccessLevelSyntax.allCases.map { accessLevel in
    (
        InterfaceConfiguration(accessLevel: accessLevel),
        MockConfiguration(interfaceAccessLevel: accessLevel)
    )
}

func assertMocked(
    _ interface: String,
    generates mock: String,
    diagnostics: [DiagnosticSpec] = [],
    applyFixIts: [String]? = nil,
    fixedSource: String? = nil,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
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
        macroSpecs: ["Mocked": MacroSpec(type: MockedMacro.self)],
        applyFixIts: applyFixIts,
        fixedSource: fixedSource,
        failureHandler: { testFailure in
            Issue.record(
                "\(testFailure.message)",
                sourceLocation: SourceLocation(
                    fileID: testFailure.location.fileID,
                    filePath: testFailure.location.filePath,
                    line: testFailure.location.line,
                    column: testFailure.location.column
                )
            )
        },
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
    )
}
#endif
