//
//  MockedMethod_GenericMethod_MetatypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/12/25.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct MockedMethod_GenericMethod_MetatypeTests {

    // MARK: Generic Type Metatype Tests

    @Test
    func genericMethodWithGenericTypeMetatypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Value.Type) -> Value.Type
            """,
            generates: """
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

            private let __method = MockReturningMethodWithParameters<
            \t(Any.Type),
            \tAny.Type
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Any.Type),
            \tAny.Type
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithGenericTypeMetatypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Value.Type) -> Value.Type \
            where Value: Sendable, Value: Comparable & Hashable
            """,
            generates: """
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
            
            private let __method = MockReturningMethodWithParameters<
            \t(any (Equatable & Sendable & Comparable & Hashable).Type),
            \tany (Equatable & Sendable & Comparable & Hashable).Type
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(any (Equatable & Sendable & Comparable & Hashable).Type),
            \tany (Equatable & Sendable & Comparable & Hashable).Type
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Opaque Type Metatype Tests

    @Test
    func genericMethodWithOpaqueTypeMetatypeWithOneConstraint() {
        assertMockedMethod(
            """
            func method(parameter: (some Equatable).Type)
            """,
            generates: """
            func method(parameter: (some Equatable).Type) {
                self.__method.invoke((parameter))
            }
            
            private let __method = MockVoidMethodWithParameters<
            \t(any Equatable.Type)
            >.makeMethod()
            
            var _method: MockVoidMethodWithParameters<
            \t(any Equatable.Type)
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithOpaqueTypeMetatypeWithMultipleConstraints() {
        assertMockedMethod(
            """
            func method(parameter: (some Equatable & Sendable & Comparable).Type)
            """,
            generates: """
            func method(parameter: (some Equatable & Sendable & Comparable).Type) {
                self.__method.invoke((parameter))
            }
            
            private let __method = MockVoidMethodWithParameters<
            \t(any (Equatable & Sendable & Comparable).Type)
            >.makeMethod()
            
            var _method: MockVoidMethodWithParameters<
            \t(any (Equatable & Sendable & Comparable).Type)
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
