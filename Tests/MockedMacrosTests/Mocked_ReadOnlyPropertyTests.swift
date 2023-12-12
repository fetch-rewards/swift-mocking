//
//  Mocked_ReadOnlyPropertyTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import MockedMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class Mocked_ReadOnlyPropertyTests: XCTestCase {

    // MARK: Read-Only Property Tests

    func testReadOnlyProperty() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var property: String { get }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __property = MockReadOnlyProperty<String> .makeProperty(
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
    }

    // MARK: Read-Only Async Property Tests

    func testReadOnlyAsyncProperty() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var property: String { get async }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __property = MockReadOnlyAsyncProperty<String> .makeProperty(
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
    }

    // MARK: Read-Only Throwing Property Tests

    func testReadOnlyThrowingProperty() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var property: String { get throws }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __property = MockReadOnlyThrowingProperty<String> .makeProperty(
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
    }

    // MARK: Read-Only Async Throwing Property Tests

    func testReadOnlyAsyncThrowingProperty() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var property: String { get async throws }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __property = MockReadOnlyAsyncThrowingProperty<String> .makeProperty(
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
}
#endif
