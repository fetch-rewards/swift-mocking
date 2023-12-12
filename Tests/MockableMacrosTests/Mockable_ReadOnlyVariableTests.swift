//
//  Mockable_ReadOnlyVariableTests.swift
//  MockableMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockableMacros)
import MockableMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class Mockable_ReadOnlyVariableTests: XCTestCase {

    // MARK: Read-Only Variable Tests

    func testReadOnlyVariable() {
        testMockable { interface, mock in
            assertMockable(
                """
                \(interface.accessLevel) protocol Dependency {
                    var variable: String { get }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __variable = MockReadOnlyVariable<String> .makeVariable(
                            exposedVariableDescription: MockImplementationDescription(
                                type: DependencyMock.self,
                                member: "_variable"
                            )
                        )
                        \(mock.memberModifiers)var _variable: MockReadOnlyVariable<String> {
                            self.__variable.variable
                        }
                        \(mock.memberModifiers)var variable: String {
                            self.__variable.get()
                        }
                    }
                    """
            )
        }
    }

    // MARK: Read-Only Async Variable Tests

    func testReadOnlyAsyncVariable() {
        testMockable { interface, mock in
            assertMockable(
                """
                \(interface.accessLevel) protocol Dependency {
                    var variable: String { get async }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __variable = MockReadOnlyAsyncVariable<String> .makeVariable(
                            exposedVariableDescription: MockImplementationDescription(
                                type: DependencyMock.self,
                                member: "_variable"
                            )
                        )
                        \(mock.memberModifiers)var _variable: MockReadOnlyAsyncVariable<String> {
                            self.__variable.variable
                        }
                        \(mock.memberModifiers)var variable: String {
                            get async {
                                await self.__variable.get()
                            }
                        }
                    }
                    """
            )
        }
    }

    // MARK: Read-Only Throwing Variable Tests

    func testReadOnlyThrowingVariable() {
        testMockable { interface, mock in
            assertMockable(
                """
                \(interface.accessLevel) protocol Dependency {
                    var variable: String { get throws }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __variable = MockReadOnlyThrowingVariable<String> .makeVariable(
                            exposedVariableDescription: MockImplementationDescription(
                                type: DependencyMock.self,
                                member: "_variable"
                            )
                        )
                        \(mock.memberModifiers)var _variable: MockReadOnlyThrowingVariable<String> {
                            self.__variable.variable
                        }
                        \(mock.memberModifiers)var variable: String {
                            get throws {
                                try self.__variable.get()
                            }
                        }
                    }
                    """
            )
        }
    }

    // MARK: Read-Only Async Throwing Variable Tests

    func testReadOnlyAsyncThrowingVariable() {
        testMockable { interface, mock in
            assertMockable(
                """
                \(interface.accessLevel) protocol Dependency {
                    var variable: String { get async throws }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __variable = MockReadOnlyAsyncThrowingVariable<String> .makeVariable(
                            exposedVariableDescription: MockImplementationDescription(
                                type: DependencyMock.self,
                                member: "_variable"
                            )
                        )
                        \(mock.memberModifiers)\
                    var _variable: MockReadOnlyAsyncThrowingVariable<String> {
                            self.__variable.variable
                        }
                        \(mock.memberModifiers)var variable: String {
                            get async throws {
                                try await self.__variable.get()
                            }
                        }
                    }
                    """
            )
        }
    }
}
#endif
