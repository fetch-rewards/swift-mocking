//
//  MockedMethod_GenericMethod_ArrayTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/8/25.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct MockedMethod_GenericMethod_ArrayTypeTests {

    // MARK: Array Type Tests

    @Test
    func genericMethodWithArrayTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: [Value]) -> [Value]
            """,
            generates: """
            func method<Value>(parameter: [Value]) -> [Value] {
                guard
                    let value = self.__method.invoke((parameter)) as? [Value]
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type [Value].
                        \"""
                    )
                }
                return value
            }
            
            private let __method = MockReturningMethodWithParameters<
            \t([Any]),
            \t[Any]
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t([Any]),
            \t[Any]
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithArrayTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: [Value]) -> [Value] \
            where Value: Sendable, Value: Comparable & Hashable
            """,
            generates: """
            func method<Value: Equatable>(parameter: [Value]) -> [Value] \
            where Value: Sendable, Value: Comparable & Hashable {
                guard
                    let value = self.__method.invoke((parameter)) as? [Value]
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type [Value].
                        \"""
                    )
                }
                return value
            }
            
            private let __method = MockReturningMethodWithParameters<
            \t([any (Equatable & Sendable & Comparable & Hashable)]),
            \t[any (Equatable & Sendable & Comparable & Hashable)]
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t([any (Equatable & Sendable & Comparable & Hashable)]),
            \t[any (Equatable & Sendable & Comparable & Hashable)]
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
