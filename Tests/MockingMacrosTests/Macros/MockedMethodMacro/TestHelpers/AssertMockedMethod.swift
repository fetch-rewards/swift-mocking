//
//  AssertMockedMethod.swift
//  MockingMacrosTests
//
//  Created by Gray Campbell on 1/21/25.
//

#if canImport(MockingMacros)
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockingMacros

func assertMockedMethod(
    _ method: String,
    named mockMethodName: String,
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
        @_MockedMethod(
            mockName: "DependencyMock",
            isMockAnActor: false,
            mockMethodName: "\(mockMethodName)"
        )
        \(method)
        """,
        expandedSource: expandedSource,
        diagnostics: diagnostics,
        macroSpecs: [
            "_MockedMethod": MacroSpec(type: MockedMethodMacro.self),
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
