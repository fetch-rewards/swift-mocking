//
//  Mocked_ReadWritePropertyTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import MockedMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class Mocked_ReadWritePropertyTests: XCTestCase {

    // MARK: Read-Write Property Tests

    func testReadWriteProperty() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var property: String { get set }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __property = MockReadWriteProperty<String> .makeProperty(
                            exposedPropertyDescription: MockImplementationDescription(
                                type: DependencyMock.self,
                                member: "_property"
                            )
                        )
                        \(mock.memberModifiers)var _property: MockReadWriteProperty<String> {
                            self.__property.property
                        }
                        \(mock.memberModifiers)var property: String {
                            get {
                                self.__property.get()
                            }
                            set {
                                self.__property.set(newValue)
                            }
                        }
                    }
                    """
            )
        }
    }
}
#endif
