//
//  Mocked_GenericMethod_FunctionTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/11/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_GenericMethod_FunctionTypeTests {

    // MARK: Function Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithFunctionTypeAndUnconstrainedGenericParameters(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value>(parameter: @escaping (String) -> Value) \
            -> (String) -> Value
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            ((String) -> Any), (String) -> Any>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            ((String) -> Any), (String) -> Any> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Value>(parameter: @escaping (String) -> Value) \
            -> (String) -> Value {
                    guard
                        let value = self.__method.invoke((parameter)) as? (String) -> Value
                    else {
                        fatalError(
                            \"""
                            Unable to cast value returned by \\
                            self._method \\
                            to expected return type (String) -> Value.
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
    func genericMethodWithFunctionTypeAndConstrainedGenericParameters(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value: Sendable>(parameter: @escaping (String) -> Value) \
            -> (String) -> Value where Value: Equatable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            ((String) -> any (Sendable & Equatable)), \
            (String) -> any (Sendable & Equatable)>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            ((String) -> any (Sendable & Equatable)), \
            (String) -> any (Sendable & Equatable)> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Value: Sendable>(parameter: @escaping (String) -> Value) \
            -> (String) -> Value where Value: Equatable {
                    guard
                        let value = self.__method.invoke((parameter)) as? (String) -> Value
                    else {
                        fatalError(
                            \"""
                            Unable to cast value returned by \\
                            self._method \\
                            to expected return type (String) -> Value.
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
