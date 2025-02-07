//
//  AssertMockedMembers.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 2/2/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

func assertMockedMembers(
    _ mock: String,
    generates expandedMock: String,
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
        @MockedMembers
        \(mock)
        """,
        expandedSource: expandedMock,
        diagnostics: diagnostics,
        macroSpecs: [
            "MockedMembers": MacroSpec(type: MockedMembersMacro.self),
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
