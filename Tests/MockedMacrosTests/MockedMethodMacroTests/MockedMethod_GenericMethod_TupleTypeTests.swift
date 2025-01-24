//
//  MockedMethod_GenericMethod_TupleTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/11/25.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct MockedMethod_GenericMethod_TupleTypeTests {

    // MARK: Tuple Type Tests

    @Test
    func genericMethodWithTupleTypeAndUnconstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Value1, Value2>(parameter: (Value1, Value2)) \
            -> (Value1, Value2)
            """,
            generates: """
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
            
            private let __method = MockReturningMethodWithParameters<
            \t((Any, Any)),
            \t(Any, Any)
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t((Any, Any)),
            \t(Any, Any)
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithTupleTypeAndConstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Value1: Equatable, Value2: Hashable>\
            (parameter: (Value1, Value2)) -> (Value1, Value2) \
            where Value1: Sendable, Value2: Comparable
            """,
            generates: """
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
            
            private let __method = MockReturningMethodWithParameters<
            \t((any (Equatable & Sendable), any (Hashable & Comparable))),
            \t(any (Equatable & Sendable), any (Hashable & Comparable))
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t((any (Equatable & Sendable), any (Hashable & Comparable))),
            \t(any (Equatable & Sendable), any (Hashable & Comparable))
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
