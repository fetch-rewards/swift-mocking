//
//  Mocked_ReadWritePropertyTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_ReadWritePropertyTests {

    // MARK: Read-Write Property Tests

    @Test(arguments: testConfigurations)
    func readWriteProperty(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
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

    @Test(arguments: testConfigurations)
    func readWritePropertyWithMutatingGet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
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

    @Test(arguments: testConfigurations)
    func readWritePropertyWithNonMutatingGet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
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

    @Test(arguments: testConfigurations)
    func readWritePropertyWithMutatingSet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
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

    @Test(arguments: testConfigurations)
    func readWritePropertyWithNonMutatingSet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
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

    @Test(arguments: testConfigurations)
    func readWritePropertyWithMutatingGetAndMutatingSet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
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

    @Test(arguments: testConfigurations)
    func readWritePropertyWithNonMutatingGetAndMutatingSet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
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

    @Test(arguments: testConfigurations)
    func readWritePropertyWithMutatingGetAndNonMutatingSet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
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

    @Test(arguments: testConfigurations)
    func readWritePropertyWithNonMutatingGetAndNonMutatingSet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
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
#endif
