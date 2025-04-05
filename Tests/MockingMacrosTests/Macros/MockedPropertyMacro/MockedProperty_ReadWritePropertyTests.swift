//
//  MockedProperty_ReadWritePropertyTests.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
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
}
#endif
