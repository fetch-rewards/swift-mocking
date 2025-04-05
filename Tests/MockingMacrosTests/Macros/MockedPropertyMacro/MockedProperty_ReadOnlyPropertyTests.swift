//
//  MockedProperty_ReadOnlyPropertyTests.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedProperty_ReadOnlyPropertyTests {

    // MARK: Read-Only Property Tests

    @Test
    func readOnlyProperty() {
        assertMockedProperty(
            """
            var property: String
            """,
            ofType: ".readOnly",
            generates: """
            var property: String {
                get {
                    self.__property.get()
                }
            }
            
            private let __property = MockReadOnlyProperty<
            \tString
            >.makeProperty(
                exposedPropertyDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_property"
                )
            )
            
            var _property: MockReadOnlyProperty<
            \tString
            > {
                self.__property.property
            }
            """
        )
    }

    // MARK: Read-Only Async Property Tests

    @Test
    func readOnlyAsyncProperty() {
        assertMockedProperty(
            """
            var property: String
            """,
            ofType: ".readOnly(.async)",
            generates: """
            var property: String {
                get async {
                    await self.__property.get()
                }
            }
            
            private let __property = MockReadOnlyAsyncProperty<
            \tString
            >.makeProperty(
                exposedPropertyDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_property"
                )
            )
            
            var _property: MockReadOnlyAsyncProperty<
            \tString
            > {
                self.__property.property
            }
            """
        )
    }

    // MARK: Read-Only Throwing Property Tests

    @Test
    func readOnlyThrowingProperty() {
        assertMockedProperty(
            """
            var property: String
            """,
            ofType: ".readOnly(.throws)",
            generates: """
            var property: String {
                get throws {
                    try self.__property.get()
                }
            }
            
            private let __property = MockReadOnlyThrowingProperty<
            \tString
            >.makeProperty(
                exposedPropertyDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_property"
                )
            )
            
            var _property: MockReadOnlyThrowingProperty<
            \tString
            > {
                self.__property.property
            }
            """
        )
    }

    // MARK: Read-Only Async Throwing Property Tests

    @Test
    func readOnlyAsyncThrowingProperty() {
        assertMockedProperty(
            """
            var property: String
            """,
            ofType: ".readOnly(.async, .throws)",
            generates: """
            var property: String {
                get async throws {
                    try await self.__property.get()
                }
            }
            
            private let __property = MockReadOnlyAsyncThrowingProperty<
            \tString
            >.makeProperty(
                exposedPropertyDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_property"
                )
            )
            
            var _property: MockReadOnlyAsyncThrowingProperty<
            \tString
            > {
                self.__property.property
            }
            """
        )
    }
}
#endif
