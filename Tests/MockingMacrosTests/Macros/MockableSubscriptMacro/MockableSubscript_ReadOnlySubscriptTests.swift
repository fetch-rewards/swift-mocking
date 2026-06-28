//
//  MockableSubscript_ReadOnlySubscriptTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockableSubscript_ReadOnlySubscriptTests {

    // MARK: Read-Only Subscript Tests

    @Test
    func readOnlySubscript() {
        assertMockableSubscript(
            """
            subscript(key: String) -> String?
            """,
            ofType: ".readOnly",
            generates: """
            subscript(key: String) -> String?
            """
        )
    }
}
#endif
