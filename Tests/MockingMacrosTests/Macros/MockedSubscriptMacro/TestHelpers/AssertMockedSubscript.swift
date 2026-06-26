//
//  AssertMockedSubscript.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockingMacros

func assertMockedSubscript(
    _ declaration: String,
    ofType subscriptType: String,
    named mockSubscriptName: String,
    isMockAnActor: Bool = false,
    generates expandedSource: String,
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
        @_MockedSubscript(
            \(subscriptType),
            mockName: "DependencyMock",
            isMockAnActor: \(isMockAnActor),
            mockSubscriptName: "\(mockSubscriptName)"
        )
        \(declaration)
        """,
        expandedSource: expandedSource,
        diagnostics: diagnostics,
        macroSpecs: [
            "_MockedSubscript": MacroSpec(type: MockedSubscriptMacro.self),
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
