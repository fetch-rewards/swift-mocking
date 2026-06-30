//
//  MockedSubscript_ReadWriteSubscriptTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedSubscript_ReadWriteSubscriptTests {

    // MARK: Read-Write Subscript Tests

    @Test
    func readWriteSubscript() {
        assertMockedSubscript(
            """
            subscript(key: String) -> String?
            """,
            ofType: ".readWrite",
            named: "subscriptKey",
            generates: """
            subscript(key: String) -> String? {
                get {
                    self.__subscriptKey.get(key)
                }
                set {
                    self.__subscriptKey.set(key, newValue)
                }
            }

            private let __subscriptKey = MockReadWriteSubscript<
            \tString,
            \t(String)?
            >.makeSubscript(
                exposedSubscriptDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_subscriptKey"
                )
            )

            var _subscriptKey: MockReadWriteSubscript<
            \tString,
            \t(String)?
            > {
                self.__subscriptKey.`subscript`
            }
            """
        )
    }
}
#endif
