//
//  Mocked_GenericMethod_OpaqueTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/11/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_GenericMethod_OpaqueTypeTests {

    // MARK: Opaque Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithOpaqueTypeWithOneConstraint(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method(parameter: some Equatable)
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockVoidMethodWithParameters<(any Equatable)>\
            .makeMethod()
                \(mock.memberModifiers)\
            var _method: MockVoidMethodWithParameters<(any Equatable)> {
                    self.__method.method
                }
                \(mock.memberModifiers)func method(parameter: some Equatable) {
                    self.__method.invoke((parameter))
                }
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func genericMethodWithOpaqueTypeWithMultipleConstraints(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method(parameter: some Equatable & Sendable & Comparable)
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockVoidMethodWithParameters<\
            (any (Equatable & Sendable & Comparable))>.makeMethod()
                \(mock.memberModifiers)var _method: MockVoidMethodWithParameters<\
            (any (Equatable & Sendable & Comparable))> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method(parameter: some Equatable & Sendable & Comparable) {
                    self.__method.invoke((parameter))
                }
            }
            """
        )
    }
}
#endif
