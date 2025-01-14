//
//  Mocked_GenericMethod_AttributedTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/10/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_GenericMethod_AttributedTypeTests {

    // MARK: Attributed Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithAttributedTypeAndUnconstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value>(parameter: inout Value)
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockVoidMethodWithParameters<(Any)>.makeMethod()
                \(mock.memberModifiers)var _method: MockVoidMethodWithParameters<(Any)> {
                    self.__method.method
                }
                \(mock.memberModifiers)func method<Value>(parameter: inout Value) {
                    self.__method.invoke((parameter))
                }
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func genericMethodWithAttributedTypeAndConstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value: Equatable>(parameter: inout Value) \
            where Value: Sendable, Value: Comparable & Hashable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockVoidMethodWithParameters<\
            (any (Equatable & Sendable & Comparable & Hashable))>.makeMethod()
                \(mock.memberModifiers)var _method: MockVoidMethodWithParameters<\
            (any (Equatable & Sendable & Comparable & Hashable))> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Value: Equatable>(parameter: inout Value) \
            where Value: Sendable, Value: Comparable & Hashable {
                    self.__method.invoke((parameter))
                }
            }
            """
        )
    }
}
#endif
