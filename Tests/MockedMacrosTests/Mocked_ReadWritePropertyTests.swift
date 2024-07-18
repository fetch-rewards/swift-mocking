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
                        private let __property = MockReadWriteProperty<String>.makeProperty(
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

    func testReadWritePropertyWithMutatingGet() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var property: String { mutating get set }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __property = MockReadWriteProperty<String>.makeProperty(
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

    func testReadWritePropertyWithNonMutatingGet() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var property: String { nonmutating get set }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __property = MockReadWriteProperty<String>.makeProperty(
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

    func testReadWritePropertyWithMutatingSet() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var property: String { get mutating set }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __property = MockReadWriteProperty<String>.makeProperty(
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

    func testReadWritePropertyWithNonMutatingSet() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var property: String { get nonmutating set }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __property = MockReadWriteProperty<String>.makeProperty(
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

    func testReadWritePropertyWithMutatingGetAndMutatingSet() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var property: String { mutating get mutating set }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __property = MockReadWriteProperty<String>.makeProperty(
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

    func testReadWritePropertyWithNonMutatingGetAndMutatingSet() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var property: String { nonmutating get mutating set }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __property = MockReadWriteProperty<String>.makeProperty(
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

    func testReadWritePropertyWithMutatingGetAndNonMutatingSet() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var property: String { mutating get nonmutating set }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __property = MockReadWriteProperty<String>.makeProperty(
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

    func testReadWritePropertyWithNonMutatingGetAndNonMutatingSet() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var property: String { nonmutating get nonmutating set }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __property = MockReadWriteProperty<String>.makeProperty(
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
