//
//  Mocked_GenericMethod_TupleTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/11/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_GenericMethod_TupleTypeTests {

    // MARK: Tuple Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithTupleTypeAndUnconstrainedGenericParameters(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value1, Value2>(parameter: (Value1, Value2)) \
            -> (Value1, Value2)
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            ((Any, Any)), (Any, Any)>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            ((Any, Any)), (Any, Any)> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Value1, Value2>(parameter: (Value1, Value2)) \
            -> (Value1, Value2) {
                    guard
                        let value = self.__method.invoke((parameter)) as? (Value1, Value2)
                    else {
                        fatalError(
                            \"""
                            Unable to cast value returned by \\
                            self._method \\
                            to expected return type (Value1, Value2).
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
    func genericMethodWithTupleTypeAndConstrainedGenericParameters(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value1: Equatable, Value2: Hashable>\
            (parameter: (Value1, Value2)) -> (Value1, Value2) \
            where Value1: Sendable, Value2: Comparable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            ((any (Equatable & Sendable), any (Hashable & Comparable))), \
            (any (Equatable & Sendable), any (Hashable & Comparable))>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            ((any (Equatable & Sendable), any (Hashable & Comparable))), \
            (any (Equatable & Sendable), any (Hashable & Comparable))> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Value1: Equatable, Value2: Hashable>\
            (parameter: (Value1, Value2)) -> (Value1, Value2) \
            where Value1: Sendable, Value2: Comparable {
                    guard
                        let value = self.__method.invoke((parameter)) as? (Value1, Value2)
                    else {
                        fatalError(
                            \"""
                            Unable to cast value returned by \\
                            self._method \\
                            to expected return type (Value1, Value2).
                            \"""
                        )
                    }
                    return value
                }
            }
            """
        )
    }
}
#endif
