//
//  MockableSubscript_ReadWriteSubscriptTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockableSubscript_ReadWriteSubscriptTests {

    // MARK: Read-Write Subscript Tests

    @Test
    func readWriteSubscript() {
        assertMockableSubscript(
            """
            subscript(key: String) -> String?
            """,
            ofType: ".readWrite",
            generates: """
            subscript(key: String) -> String?
            """
        )
    }
}
#endif
