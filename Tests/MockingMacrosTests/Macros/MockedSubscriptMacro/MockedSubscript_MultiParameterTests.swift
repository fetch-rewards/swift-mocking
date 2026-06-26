//
//  MockedSubscript_MultiParameterTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedSubscript_MultiParameterTests {

    // MARK: Multi-Parameter Read-Only Subscript Tests

    @Test
    func multiParameterReadOnlySubscript() {
        assertMockedSubscript(
            """
            subscript(row: Int, column: Int) -> Double
            """,
            ofType: ".readOnly",
            named: "subscriptRowColumn",
            generates: """
            subscript(row: Int, column: Int) -> Double {
                get {
                    self.__subscriptRowColumn.get((row, column))
                }
            }

            private let __subscriptRowColumn = MockReadOnlySubscript<
            \t(Int, Int),
            \tDouble
            >.makeSubscript(
                exposedSubscriptDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_subscriptRowColumn"
                )
            )

            var _subscriptRowColumn: MockReadOnlySubscript<
            \t(Int, Int),
            \tDouble
            > {
                self.__subscriptRowColumn.`subscript`
            }
            """
        )
    }

    // MARK: Multi-Parameter Read-Write Subscript Tests

    @Test
    func multiParameterReadWriteSubscript() {
        assertMockedSubscript(
            """
            subscript(row: Int, column: Int) -> Double
            """,
            ofType: ".readWrite",
            named: "subscriptRowColumn",
            generates: """
            subscript(row: Int, column: Int) -> Double {
                get {
                    self.__subscriptRowColumn.get((row, column))
                }
                set {
                    self.__subscriptRowColumn.set((row, column), newValue)
                }
            }

            private let __subscriptRowColumn = MockReadWriteSubscript<
            \t(Int, Int),
            \tDouble
            >.makeSubscript(
                exposedSubscriptDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_subscriptRowColumn"
                )
            )

            var _subscriptRowColumn: MockReadWriteSubscript<
            \t(Int, Int),
            \tDouble
            > {
                self.__subscriptRowColumn.`subscript`
            }
            """
        )
    }
}
#endif
