//
//  MockedMethod_GenericMethod_MemberTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/12/25.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct MockedMethod_GenericMethod_MemberTypeTests {

    // MARK: Array Member Type Tests

    @Test
    func genericMethodWithArrayMemberTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Swift.Array<Value>) -> Swift.Array<Value>
            """,
            named: "method",
            generates: """
            func method<Value>(parameter: Swift.Array<Value>) -> Swift.Array<Value> {
                guard
                    let value = self.__method.invoke((parameter)) as? Swift.Array<Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Swift.Array<Value>.
                        \"""
                    )
                }
                return value
            }

            private let __method = MockReturningMethodWithParameters<
            \t(Swift.Array<Any>),
            \tSwift.Array<Any>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Swift.Array<Any>),
            \tSwift.Array<Any>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithArrayMemberTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Swift.Array<Value>) \
            -> Swift.Array<Value> where Value: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Value: Equatable>(parameter: Swift.Array<Value>) \
            -> Swift.Array<Value> where Value: Sendable, Value: Comparable & Hashable {
                guard
                    let value = self.__method.invoke((parameter)) as? Swift.Array<Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Swift.Array<Value>.
                        \"""
                    )
                }
                return value
            }

            private let __method = MockReturningMethodWithParameters<
            \t(Swift.Array<any (Equatable & Sendable & Comparable & Hashable)>),
            \tSwift.Array<any (Equatable & Sendable & Comparable & Hashable)>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Swift.Array<any (Equatable & Sendable & Comparable & Hashable)>),
            \tSwift.Array<any (Equatable & Sendable & Comparable & Hashable)>
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Dictionary Member Type Tests

    @Test
    func genericMethodWithDictionaryMemberTypeAndUnconstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Key, Value>(parameter: Swift.Dictionary<Key, Value>) \
            -> Swift.Dictionary<Key, Value>
            """,
            named: "method",
            generates: """
            func method<Key, Value>(parameter: Swift.Dictionary<Key, Value>) \
            -> Swift.Dictionary<Key, Value> {
                guard
                    let value = self.__method.invoke((parameter)) \
            as? Swift.Dictionary<Key, Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Swift.Dictionary<Key, Value>.
                        \"""
                    )
                }
                return value
            }

            private let __method = MockReturningMethodWithParameters<
            \t(Swift.Dictionary<AnyHashable, Any>),
            \tSwift.Dictionary<AnyHashable, Any>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Swift.Dictionary<AnyHashable, Any>),
            \tSwift.Dictionary<AnyHashable, Any>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithDictionaryMemberTypeAndConstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Key: Hashable, Value: Equatable>\
            (parameter: Swift.Dictionary<Key, Value>) -> Swift.Dictionary<Key, Value> \
            where Key: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Key: Hashable, Value: Equatable>\
            (parameter: Swift.Dictionary<Key, Value>) -> Swift.Dictionary<Key, Value> \
            where Key: Sendable, Value: Comparable & Hashable {
                guard
                    let value = self.__method.invoke((parameter)) as? Swift.Dictionary<Key, Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Swift.Dictionary<Key, Value>.
                        \"""
                    )
                }
                return value
            }

            private let __method = MockReturningMethodWithParameters<
            \t(Swift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>),
            \tSwift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Swift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>),
            \tSwift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Optional Member Type Tests

    @Test
    func genericMethodWithOptionalMemberTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Swift.Optional<Value>) \
            -> Swift.Optional<Value>
            """,
            named: "method",
            generates: """
            func method<Value>(parameter: Swift.Optional<Value>) \
            -> Swift.Optional<Value> {
                guard
                    let value = self.__method.invoke((parameter)) \
            as? Swift.Optional<Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Swift.Optional<Value>.
                        \"""
                    )
                }
                return value
            }

            private let __method = MockReturningMethodWithParameters<
            \t(Swift.Optional<Any>),
            \tSwift.Optional<Any>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Swift.Optional<Any>),
            \tSwift.Optional<Any>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithOptionalMemberTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Swift.Optional<Value>) \
            -> Swift.Optional<Value> where Value: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Value: Equatable>(parameter: Swift.Optional<Value>) \
            -> Swift.Optional<Value> where Value: Sendable, Value: Comparable & Hashable {
                guard
                    let value = self.__method.invoke((parameter)) \
            as? Swift.Optional<Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Swift.Optional<Value>.
                        \"""
                    )
                }
                return value
            }

            private let __method = MockReturningMethodWithParameters<
            \t(Swift.Optional<any (Equatable & Sendable & Comparable & Hashable)>),
            \tSwift.Optional<any (Equatable & Sendable & Comparable & Hashable)>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Swift.Optional<any (Equatable & Sendable & Comparable & Hashable)>),
            \tSwift.Optional<any (Equatable & Sendable & Comparable & Hashable)>
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Set Member Type Tests

    @Test
    func genericMethodWithSetMemberTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Swift.Set<Value>) -> Swift.Set<Value>
            """,
            named: "method",
            generates: """
            func method<Value>(parameter: Swift.Set<Value>) -> Swift.Set<Value> {
                guard
                    let value = self.__method.invoke((parameter)) as? Swift.Set<Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Swift.Set<Value>.
                        \"""
                    )
                }
                return value
            }

            private let __method = MockReturningMethodWithParameters<
            \t(Swift.Set<AnyHashable>),
            \tSwift.Set<AnyHashable>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Swift.Set<AnyHashable>),
            \tSwift.Set<AnyHashable>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithSetMemberTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Swift.Set<Value>) \
            -> Swift.Set<Value> where Value: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Value: Equatable>(parameter: Swift.Set<Value>) \
            -> Swift.Set<Value> where Value: Sendable, Value: Comparable & Hashable {
                guard
                    let value = self.__method.invoke((parameter)) as? Swift.Set<Value>
                else {
                    fatalError(
                        \"""
                        Unable to cast value returned by \\
                        self._method \\
                        to expected return type Swift.Set<Value>.
                        \"""
                    )
                }
                return value
            }

            private let __method = MockReturningMethodWithParameters<
            \t(Swift.Set<AnyHashable>),
            \tSwift.Set<AnyHashable>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t(Swift.Set<AnyHashable>),
            \tSwift.Set<AnyHashable>
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
