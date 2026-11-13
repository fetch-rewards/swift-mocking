//
//  MockedProperty_ReadWritePropertyTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedProperty_ReadWritePropertyTests {

    // MARK: Read-Write Property Tests

    @Test
    func readWriteProperty() {
        assertMockedProperty(
            """
            var property: String
            """,
            ofType: ".readWrite",
            generates: """
            var property: String {
                get {
                    self.__property.get()
                }
                set {
                    self.__property.set(newValue)
                }
            }

            private let __property = MockReadWriteProperty<
            \tString
            >.makeProperty(
                exposedPropertyDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_property"
                )
            )

            var _property: MockReadWriteProperty<
            \tString
            > {
                self.__property.property
            }
            """
        )
    }

    // MARK: Backticked Property Name Tests

    @Test
    func readWritePropertyWithBacktickedName() {
        assertMockedProperty(
            """
            var `default`: String
            """,
            ofType: ".readWrite",
            generates: """
            var `default`: String {
                get {
                    self.__default.get()
                }
                set {
                    self.__default.set(newValue)
                }
            }

            private let __default = MockReadWriteProperty<
            \tString
            >.makeProperty(
                exposedPropertyDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_default"
                )
            )

            var _default: MockReadWriteProperty<
            \tString
            > {
                self.__default.property
            }
            """
        )
    }
}
#endif
