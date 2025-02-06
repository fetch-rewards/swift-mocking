//
//  MockedMethod_GenericMethod_FunctionTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/11/25.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct MockedMethod_GenericMethod_FunctionTypeTests {

    // MARK: Function Type Tests

    @Test
    func genericMethodWithFunctionTypeAndUnconstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Value>(parameter: @escaping (String) -> Value) \
            -> (String) -> Value
            """,
            named: "method",
            generates: """
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
            
            private let __method = MockReturningMethodWithParameters<
            \t((String) -> Any),
            \t(String) -> Any
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t((String) -> Any),
            \t(String) -> Any
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithFunctionTypeAndConstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Value: Sendable>(parameter: @escaping (String) -> Value) \
            -> (String) -> Value where Value: Equatable
            """,
            named: "method",
            generates: """
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
            
            private let __method = MockReturningMethodWithParameters<
            \t((String) -> any (Sendable & Equatable)),
            \t(String) -> any (Sendable & Equatable)
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t((String) -> any (Sendable & Equatable)),
            \t(String) -> any (Sendable & Equatable)
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
