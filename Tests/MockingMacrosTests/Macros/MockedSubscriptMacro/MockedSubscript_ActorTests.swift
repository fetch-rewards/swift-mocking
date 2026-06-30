//
//  MockedSubscript_ActorTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedSubscript_ActorTests {

    // MARK: Actor Tests

    @Test
    func readOnlySubscriptInActor() {
        assertMockedSubscript(
            """
            subscript(key: String) -> String?
            """,
            ofType: ".readOnly",
            named: "subscriptKey",
            isMockAnActor: true,
            generates: """
            subscript(key: String) -> String? {
                get {
                    self.__subscriptKey.get(key)
                }
            }

            private nonisolated let __subscriptKey = MockReadOnlySubscript<
            \tString,
            \tString?
            >.makeSubscript(
                exposedSubscriptDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_subscriptKey"
                )
            )

            nonisolated var _subscriptKey: MockReadOnlySubscript<
            \tString,
            \tString?
            > {
                self.__subscriptKey.`subscript`
            }
            """
        )
    }

    @Test
    func readWriteSubscriptInActor() {
        assertMockedSubscript(
            """
            subscript(key: String) -> String?
            """,
            ofType: ".readWrite",
            named: "subscriptKey",
            isMockAnActor: true,
            generates: """
            subscript(key: String) -> String? {
                get {
                    self.__subscriptKey.get(key)
                }
                set {
                    self.__subscriptKey.set(key, newValue)
                }
            }

            private nonisolated let __subscriptKey = MockReadWriteSubscript<
            \tString,
            \tString?
            >.makeSubscript(
                exposedSubscriptDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_subscriptKey"
                )
            )

            nonisolated var _subscriptKey: MockReadWriteSubscript<
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
