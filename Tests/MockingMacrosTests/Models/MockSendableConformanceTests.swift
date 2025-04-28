//
//  MockSendableConformanceTests.swift
//
//  Copyright © 2025 Fetch.
//

import SwiftSyntax
import Testing
@testable import MockingMacros

struct MockSendableConformanceTests {

    // MARK: Init from argument tests

    @Test("Initializes as .checked from a valid checked argument.")
    func initCheckedFromArgument() {
        let sendableConformance = MockSendableConformance(
            argument: argument(base: nil, name: "checked")
        )
        #expect(sendableConformance == .checked)
    }

    @Test("Initializes as .unchecked from a valid unchecked argument.")
    func initUncheckedFromArgument() {
        let sendableConformance = MockSendableConformance(
            argument: argument(base: nil, name: "unchecked")
        )
        #expect(sendableConformance == .unchecked)
    }

    @Test("Initializes as nil from an unrecognized argument.")
    func initNilFromArgument() {
        let sendableConformance = MockSendableConformance(
            argument: argument(base: nil, name: "unrecognized")
        )
        #expect(sendableConformance == nil)
    }

    @Test("Initializes from argument when base is included.")
    func initFromArgumentWithBase() {
        let sendableConformance = MockSendableConformance(
            argument: argument(base: "MockSendableConformance", name: "checked")
        )
        #expect(sendableConformance == .checked)
    }

    // MARK: Helper functions

    /// Returns the sendable conformance argument syntax for the provided base
    /// and name.
    ///
    /// ```swift
    /// argument(base: "SomeEnum", name: "someCase")
    /// // Represents
    /// sendableConformance: SomeEnum.someCase
    /// ```
    private func argument(base: String?, name: String) -> LabeledExprSyntax {
        LabeledExprSyntax(
            label: .identifier("sendableConformance"),
            colon: .colonToken(),
            expression: MemberAccessExprSyntax(
                base: base.map {
                    DeclReferenceExprSyntax(baseName: .identifier($0))
                },
                period: .periodToken(),
                name: .identifier(name)
            )
        )
    }
}
