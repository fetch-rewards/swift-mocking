//
//  AssertMocked.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/21/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

func assertMocked(
    _ interface: String,
    compilationCondition: String? = nil,
    generates mock: String,
    diagnostics: [DiagnosticSpec] = [],
    applyFixIts: [String]? = nil,
    fixedSource: String? = nil,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
) {
    var arguments: [String] = []

    if let compilationCondition {
        arguments.append("compilationCondition: \"\(compilationCondition)\"")
    }

    var macro = "@Mocked"

    if !arguments.isEmpty {
        macro += "(" + arguments.joined(separator: ", ") + ")"
    }

    assertMacroExpansion(
        """
        \(macro)
        \(interface)
        """,
        expandedSource: """
        \(interface)

        \(mock)
        """,
        diagnostics: diagnostics,
        macroSpecs: [
            "Mocked": MacroSpec(type: MockedMacro.self),
        ],
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
