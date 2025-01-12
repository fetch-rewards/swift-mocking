//
//  Mocked_GenericMethod_MetatypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/12/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_GenericMethod_MetatypeTests {

    // MARK: Generic Type Metatype Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithGenericTypeMetatypeAndUnconstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value>(parameter: Value.Type) -> Value.Type
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Any.Type), Any.Type>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)\
            var _method: MockReturningMethodWithParameters<(Any.Type), Any.Type> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Value>(parameter: Value.Type) -> Value.Type {
                    guard
                        let value = self.__method.invoke((parameter)) as? Value.Type
                    else {
                        fatalError(
                            \"""
                            Unable to cast value returned by \\
                            self._method \\
                            to expected return type Value.Type.
                            \"""
                        )
                    }
                    return value
                }
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func genericMethodWithGenericTypeMetatypeAndConstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value: Equatable>(parameter: Value.Type) -> Value.Type \
            where Value: Sendable, Value: Comparable & Hashable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (any (Equatable & Sendable & Comparable & Hashable).Type), \
            any (Equatable & Sendable & Comparable & Hashable).Type>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)\
            var _method: MockReturningMethodWithParameters<\
            (any (Equatable & Sendable & Comparable & Hashable).Type), \
            any (Equatable & Sendable & Comparable & Hashable).Type> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Value: Equatable>(parameter: Value.Type) -> Value.Type \
            where Value: Sendable, Value: Comparable & Hashable {
                    guard
                        let value = self.__method.invoke((parameter)) as? Value.Type
                    else {
                        fatalError(
                            \"""
                            Unable to cast value returned by \\
                            self._method \\
                            to expected return type Value.Type.
                            \"""
                        )
                    }
                    return value
                }
            }
            """
        )
    }

    // MARK: Opaque Type Metatype Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithOpaqueTypeMetatypeWithOneConstraint(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method(parameter: (some Equatable).Type)
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockVoidMethodWithParameters<\
            (any Equatable.Type)>.makeMethod()
                \(mock.memberModifiers)\
            var _method: MockVoidMethodWithParameters<(any Equatable.Type)> {
                    self.__method.method
                }
                \(mock.memberModifiers)func method(parameter: (some Equatable).Type) {
                    self.__method.invoke((parameter))
                }
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func genericMethodWithOpaqueTypeMetatypeWithMultipleConstraints(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method(parameter: (some Equatable & Sendable & Comparable).Type)
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockVoidMethodWithParameters<\
            (any (Equatable & Sendable & Comparable).Type)>.makeMethod()
                \(mock.memberModifiers)var _method: MockVoidMethodWithParameters<\
            (any (Equatable & Sendable & Comparable).Type)> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method(parameter: (some Equatable & Sendable & Comparable).Type) {
                    self.__method.invoke((parameter))
                }
            }
            """
        )
    }
}
#endif
