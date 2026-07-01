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
            \t(String)?
            >.makeSubscript(
                exposedSubscriptDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_subscriptKey"
                )
            )

            var _subscriptKey: MockReadOnlySubscript<
            \tString,
            \t(String)?
            > {
                self.__subscriptKey.`subscript`
            }
            """
        )
    }

    // MARK: Read-Only Async Subscript Tests

    @Test
    func readOnlyAsyncSubscript() {
        assertMockedSubscript(
            """
            subscript(key: String) -> String?
            """,
            ofType: ".readOnly(.async)",
            named: "subscriptKey",
            generates: """
            subscript(key: String) -> String? {
                get async {
                    await self.__subscriptKey.get(key)
                }
            }

            private let __subscriptKey = MockReadOnlyAsyncSubscript<
            \tString,
            \t(String)?
            >.makeSubscript(
                exposedSubscriptDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_subscriptKey"
                )
            )

            var _subscriptKey: MockReadOnlyAsyncSubscript<
            \tString,
            \t(String)?
            > {
                self.__subscriptKey.`subscript`
            }
            """
        )
    }

    // MARK: Read-Only Throwing Subscript Tests

    @Test
    func readOnlyThrowingSubscript() {
        assertMockedSubscript(
            """
            subscript(key: String) -> String?
            """,
            ofType: ".readOnly(.throws)",
            named: "subscriptKey",
            generates: """
            subscript(key: String) -> String? {
                get throws {
                    try self.__subscriptKey.get(key)
                }
            }

            private let __subscriptKey = MockReadOnlyThrowingSubscript<
            \tString,
            \t(String)?
            >.makeSubscript(
                exposedSubscriptDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_subscriptKey"
                )
            )

            var _subscriptKey: MockReadOnlyThrowingSubscript<
            \tString,
            \t(String)?
            > {
                self.__subscriptKey.`subscript`
            }
            """
        )
    }

    // MARK: Read-Only Async Throwing Subscript Tests

    @Test
    func readOnlyAsyncThrowingSubscript() {
        assertMockedSubscript(
            """
            subscript(key: String) -> String?
            """,
            ofType: ".readOnly(.async, .throws)",
            named: "subscriptKey",
            generates: """
            subscript(key: String) -> String? {
                get async throws {
                    try await self.__subscriptKey.get(key)
                }
            }

            private let __subscriptKey = MockReadOnlyAsyncThrowingSubscript<
            \tString,
            \t(String)?
            >.makeSubscript(
                exposedSubscriptDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_subscriptKey"
                )
            )

            var _subscriptKey: MockReadOnlyAsyncThrowingSubscript<
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
