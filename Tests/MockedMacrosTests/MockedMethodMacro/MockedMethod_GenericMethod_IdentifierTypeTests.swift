//
//  MockedMethod_GenericMethod_IdentifierTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/12/25.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct MockedMethod_GenericMethod_IdentifierTypeTests {

    // MARK: Array Identifier Type Tests

    @Test
    func genericMethodWithArrayIdentifierTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Array<Value>) -> Array<Value>
            """,
            generates: """
            func method<Value>(parameter: Array<Value>) -> Array<Value> {
                guard
                    let value = self.__method.invoke((parameter)) as? Array<Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Array<Value>.
                        \"""
                    )
                }
                return value
            }
            
            private let __method = MockReturningMethodWithParameters<
            \t(Array<Any>),
            \tArray<Any>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Array<Any>),
            \tArray<Any>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithArrayIdentifierTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Array<Value>) -> Array<Value> \
            where Value: Sendable, Value: Comparable & Hashable
            """,
            generates: """
            func method<Value: Equatable>(parameter: Array<Value>) -> Array<Value> \
            where Value: Sendable, Value: Comparable & Hashable {
                guard
                    let value = self.__method.invoke((parameter)) as? Array<Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Array<Value>.
                        \"""
                    )
                }
                return value
            }

            private let __method = MockReturningMethodWithParameters<
            \t(Array<any (Equatable & Sendable & Comparable & Hashable)>),
            \tArray<any (Equatable & Sendable & Comparable & Hashable)>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Array<any (Equatable & Sendable & Comparable & Hashable)>),
            \tArray<any (Equatable & Sendable & Comparable & Hashable)>
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Dictionary Identifier Type Tests

    @Test
    func genericMethodWithDictionaryIdentifierTypeAndUnconstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Key, Value>(parameter: Dictionary<Key, Value>) \
            -> Dictionary<Key, Value>
            """,
            generates: """
            func method<Key, Value>(parameter: Dictionary<Key, Value>) \
            -> Dictionary<Key, Value> {
                guard
                    let value = self.__method.invoke((parameter)) as? Dictionary<Key, Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Dictionary<Key, Value>.
                        \"""
                    )
                }
                return value
            }

            private let __method = MockReturningMethodWithParameters<
            \t(Dictionary<AnyHashable, Any>),
            \tDictionary<AnyHashable, Any>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Dictionary<AnyHashable, Any>),
            \tDictionary<AnyHashable, Any>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithDictionaryIdentifierTypeAndConstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Key: Hashable, Value: Equatable>\
            (parameter: Dictionary<Key, Value>) -> Dictionary<Key, Value> \
            where Key: Sendable, Value: Comparable & Hashable
            """,
            generates: """
            func method<Key: Hashable, Value: Equatable>\
            (parameter: Dictionary<Key, Value>) -> Dictionary<Key, Value> \
            where Key: Sendable, Value: Comparable & Hashable {
                guard
                    let value = self.__method.invoke((parameter)) as? Dictionary<Key, Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Dictionary<Key, Value>.
                        \"""
                    )
                }
                return value
            }
            
            private let __method = MockReturningMethodWithParameters<
            \t(Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>),
            \tDictionary<AnyHashable, any (Equatable & Comparable & Hashable)>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>),
            \tDictionary<AnyHashable, any (Equatable & Comparable & Hashable)>
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Optional Identifier Type Tests

    @Test
    func genericMethodWithOptionalIdentifierTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Optional<Value>) -> Optional<Value>
            """,
            generates: """
            func method<Value>(parameter: Optional<Value>) -> Optional<Value> {
                guard
                    let value = self.__method.invoke((parameter)) as? Optional<Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Optional<Value>.
                        \"""
                    )
                }
                return value
            }
            
            private let __method = MockReturningMethodWithParameters<
            \t(Optional<Any>),
            \tOptional<Any>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Optional<Any>),
            \tOptional<Any>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithOptionalIdentifierTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Optional<Value>) \
            -> Optional<Value> where Value: Sendable, Value: Comparable & Hashable
            """,
            generates: """
            func method<Value: Equatable>(parameter: Optional<Value>) \
            -> Optional<Value> where Value: Sendable, Value: Comparable & Hashable {
                guard
                    let value = self.__method.invoke((parameter)) as? Optional<Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Optional<Value>.
                        \"""
                    )
                }
                return value
            }

            private let __method = MockReturningMethodWithParameters<
            \t(Optional<any (Equatable & Sendable & Comparable & Hashable)>),
            \tOptional<any (Equatable & Sendable & Comparable & Hashable)>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Optional<any (Equatable & Sendable & Comparable & Hashable)>),
            \tOptional<any (Equatable & Sendable & Comparable & Hashable)>
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Set Identifier Type Tests

    @Test
    func genericMethodWithSetIdentifierTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Set<Value>) -> Set<Value>
            """,
            generates: """
            func method<Value>(parameter: Set<Value>) -> Set<Value> {
                guard
                    let value = self.__method.invoke((parameter)) as? Set<Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Set<Value>.
                        \"""
                    )
                }
                return value
            }

            private let __method = MockReturningMethodWithParameters<
            \t(Set<AnyHashable>),
            \tSet<AnyHashable>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Set<AnyHashable>),
            \tSet<AnyHashable>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithSetIdentifierTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Set<Value>) -> Set<Value> \
            where Value: Sendable, Value: Comparable & Hashable
            """,
            generates: """
            func method<Value: Equatable>(parameter: Set<Value>) -> Set<Value> \
            where Value: Sendable, Value: Comparable & Hashable {
                guard
                    let value = self.__method.invoke((parameter)) as? Set<Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Set<Value>.
                        \"""
                    )
                }
                return value
            }

            private let __method = MockReturningMethodWithParameters<
            \t(Set<AnyHashable>),
            \tSet<AnyHashable>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Set<AnyHashable>),
            \tSet<AnyHashable>
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
