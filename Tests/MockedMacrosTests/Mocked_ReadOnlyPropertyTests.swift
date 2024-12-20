//
//  Mocked_ReadOnlyPropertyTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_ReadOnlyPropertyTests {

    // MARK: Read-Only Property Tests

    @Test(arguments: testConfigurations)
    func readOnlyProperty(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                var property: String { get }
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __property = MockReadOnlyProperty<String>.makeProperty(
                    exposedPropertyDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_property"
                    )
                )
                \(mock.memberModifiers)var _property: MockReadOnlyProperty<String> {
                    self.__property.property
                }
                \(mock.memberModifiers)var property: String {
                    self.__property.get()
                }
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func readOnlyPropertyWithMutatingGet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                var property: String { mutating get }
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __property = MockReadOnlyProperty<String>.makeProperty(
                    exposedPropertyDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_property"
                    )
                )
                \(mock.memberModifiers)var _property: MockReadOnlyProperty<String> {
                    self.__property.property
                }
                \(mock.memberModifiers)var property: String {
                    self.__property.get()
                }
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func readOnlyPropertyWithNonMutatingGet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                var property: String { nonmutating get }
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __property = MockReadOnlyProperty<String>.makeProperty(
                    exposedPropertyDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_property"
                    )
                )
                \(mock.memberModifiers)var _property: MockReadOnlyProperty<String> {
                    self.__property.property
                }
                \(mock.memberModifiers)var property: String {
                    self.__property.get()
                }
            }
            """
        )
    }

    // MARK: Read-Only Async Property Tests

    @Test(arguments: testConfigurations)
    func readOnlyAsyncProperty(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                var property: String { get async }
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __property = MockReadOnlyAsyncProperty<String>.makeProperty(
                    exposedPropertyDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_property"
                    )
                )
                \(mock.memberModifiers)var _property: MockReadOnlyAsyncProperty<String> {
                    self.__property.property
                }
                \(mock.memberModifiers)var property: String {
                    get async {
                        await self.__property.get()
                    }
                }
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func readOnlyAsyncPropertyWithMutatingGet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                var property: String { mutating get async }
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __property = MockReadOnlyAsyncProperty<String>.makeProperty(
                    exposedPropertyDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_property"
                    )
                )
                \(mock.memberModifiers)var _property: MockReadOnlyAsyncProperty<String> {
                    self.__property.property
                }
                \(mock.memberModifiers)var property: String {
                    get async {
                        await self.__property.get()
                    }
                }
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func readOnlyAsyncPropertyWithNonMutatingGet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                var property: String { nonmutating get async }
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __property = MockReadOnlyAsyncProperty<String>.makeProperty(
                    exposedPropertyDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_property"
                    )
                )
                \(mock.memberModifiers)var _property: MockReadOnlyAsyncProperty<String> {
                    self.__property.property
                }
                \(mock.memberModifiers)var property: String {
                    get async {
                        await self.__property.get()
                    }
                }
            }
            """
        )
    }

    // MARK: Read-Only Throwing Property Tests

    @Test(arguments: testConfigurations)
    func readOnlyThrowingProperty(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                var property: String { get throws }
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __property = MockReadOnlyThrowingProperty<String>.makeProperty(
                    exposedPropertyDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_property"
                    )
                )
                \(mock.memberModifiers)var _property: MockReadOnlyThrowingProperty<String> {
                    self.__property.property
                }
                \(mock.memberModifiers)var property: String {
                    get throws {
                        try self.__property.get()
                    }
                }
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func readOnlyThrowingPropertyWithMutatingGet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                var property: String { mutating get throws }
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __property = MockReadOnlyThrowingProperty<String>.makeProperty(
                    exposedPropertyDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_property"
                    )
                )
                \(mock.memberModifiers)var _property: MockReadOnlyThrowingProperty<String> {
                    self.__property.property
                }
                \(mock.memberModifiers)var property: String {
                    get throws {
                        try self.__property.get()
                    }
                }
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func readOnlyThrowingPropertyWithNonMutatingGet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                var property: String { nonmutating get throws }
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __property = MockReadOnlyThrowingProperty<String>.makeProperty(
                    exposedPropertyDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_property"
                    )
                )
                \(mock.memberModifiers)var _property: MockReadOnlyThrowingProperty<String> {
                    self.__property.property
                }
                \(mock.memberModifiers)var property: String {
                    get throws {
                        try self.__property.get()
                    }
                }
            }
            """
        )
    }

    // MARK: Read-Only Async Throwing Property Tests

    @Test(arguments: testConfigurations)
    func readOnlyAsyncThrowingProperty(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                var property: String { get async throws }
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __property = MockReadOnlyAsyncThrowingProperty<String>.makeProperty(
                    exposedPropertyDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_property"
                    )
                )
                \(mock.memberModifiers)\
            var _property: MockReadOnlyAsyncThrowingProperty<String> {
                    self.__property.property
                }
                \(mock.memberModifiers)var property: String {
                    get async throws {
                        try await self.__property.get()
                    }
                }
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func readOnlyAsyncThrowingPropertyWithMutatingGet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                var property: String { mutating get async throws }
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __property = MockReadOnlyAsyncThrowingProperty<String>.makeProperty(
                    exposedPropertyDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_property"
                    )
                )
                \(mock.memberModifiers)\
            var _property: MockReadOnlyAsyncThrowingProperty<String> {
                    self.__property.property
                }
                \(mock.memberModifiers)var property: String {
                    get async throws {
                        try await self.__property.get()
                    }
                }
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func readOnlyAsyncThrowingPropertyWithNonMutatingGet(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                var property: String { nonmutating get async throws }
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __property = MockReadOnlyAsyncThrowingProperty<String>.makeProperty(
                    exposedPropertyDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_property"
                    )
                )
                \(mock.memberModifiers)\
            var _property: MockReadOnlyAsyncThrowingProperty<String> {
                    self.__property.property
                }
                \(mock.memberModifiers)var property: String {
                    get async throws {
                        try await self.__property.get()
                    }
                }
            }
            """
        )
    }
}
#endif
