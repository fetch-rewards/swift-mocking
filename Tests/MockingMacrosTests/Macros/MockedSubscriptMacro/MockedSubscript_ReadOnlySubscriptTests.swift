//
//  MockedSubscript_ReadOnlySubscriptTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedSubscript_ReadOnlySubscriptTests {

    // MARK: Read-Only Subscript Tests

    @Test
    func readOnlySubscript() {
        assertMockedSubscript(
            """
            subscript(key: String) -> String?
            """,
            ofType: ".readOnly",
            named: "subscriptKey",
            generates: """
            subscript(key: String) -> String? {
                get {
                    self.__subscriptKey.get(key)
                }
            }

            private let __subscriptKey = MockReadOnlySubscript<
            \tString,
            \tString?
            >.makeSubscript(
                exposedSubscriptDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_subscriptKey"
                )
            )

            var _subscriptKey: MockReadOnlySubscript<
            \tString,
            \tString?
            > {
                self.__subscriptKey.`subscript`
            }
            """
        )
    }
}
#endif
