//
//  AssertMockedProperty.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/22/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

func assertMockedProperty(
    _ property: String,
    ofType propertyType: String,
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
        @MockedProperty(
            \(propertyType),
            mockName: "DependencyMock",
            isMockAnActor: false
        )
        \(property)
        """,
        expandedSource: expandedSource,
        diagnostics: diagnostics,
        macroSpecs: [
            "MockedProperty": MacroSpec(type: MockedPropertyMacro.self),
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
