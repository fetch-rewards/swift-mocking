//
//  Mocked_GenericMethod_MemberTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/12/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_GenericMethod_MemberTypeTests {

    // MARK: Array Member Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithArrayMemberTypeAndUnconstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value>(parameter: Swift.Array<Value>) -> Swift.Array<Value>
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Swift.Array<Any>), Swift.Array<Any>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Swift.Array<Any>), Swift.Array<Any>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
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
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func genericMethodWithArrayMemberTypeAndConstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value: Equatable>(parameter: Swift.Array<Value>) \
            -> Swift.Array<Value> where Value: Sendable, Value: Comparable & Hashable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Swift.Array<any (Equatable & Sendable & Comparable & Hashable)>), \
            Swift.Array<any (Equatable & Sendable & Comparable & Hashable)>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Swift.Array<any (Equatable & Sendable & Comparable & Hashable)>), \
            Swift.Array<any (Equatable & Sendable & Comparable & Hashable)>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
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
            }
            """
        )
    }

    // MARK: Dictionary Member Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithDictionaryMemberTypeAndUnconstrainedGenericParameters(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Key, Value>(parameter: Swift.Dictionary<Key, Value>) \
            -> Swift.Dictionary<Key, Value>
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Swift.Dictionary<AnyHashable, Any>), \ 
            Swift.Dictionary<AnyHashable, Any>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Swift.Dictionary<AnyHashable, Any>), Swift.Dictionary<AnyHashable, Any>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Key, Value>(parameter: Swift.Dictionary<Key, Value>) \
            -> Swift.Dictionary<Key, Value> {
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
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func genericMethodWithDictionaryMemberTypeAndConstrainedGenericParameters(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Key: Hashable, Value: Equatable>\
            (parameter: Swift.Dictionary<Key, Value>) -> Swift.Dictionary<Key, Value> \
            where Key: Sendable, Value: Comparable & Hashable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Swift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>), \
            Swift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>>\
            .makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Swift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>), \
            Swift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
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
            }
            """
        )
    }

    // MARK: Optional Member Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithOptionalMemberTypeAndUnconstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value>(parameter: Swift.Optional<Value>) \
            -> Swift.Optional<Value>
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Swift.Optional<Any>), Swift.Optional<Any>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Swift.Optional<Any>), Swift.Optional<Any>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Value>(parameter: Swift.Optional<Value>) \
            -> Swift.Optional<Value> {
                    guard
                        let value = self.__method.invoke((parameter)) as? Swift.Optional<Value>
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
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func genericMethodWithOptionalMemberTypeAndConstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value: Equatable>(parameter: Swift.Optional<Value>) \
            -> Swift.Optional<Value> where Value: Sendable, Value: Comparable & Hashable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Swift.Optional<any (Equatable & Sendable & Comparable & Hashable)>), \
            Swift.Optional<any (Equatable & Sendable & Comparable & Hashable)>>\
            .makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Swift.Optional<any (Equatable & Sendable & Comparable & Hashable)>), \
            Swift.Optional<any (Equatable & Sendable & Comparable & Hashable)>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Value: Equatable>(parameter: Swift.Optional<Value>) \
            -> Swift.Optional<Value> where Value: Sendable, Value: Comparable & Hashable {
                    guard
                        let value = self.__method.invoke((parameter)) as? Swift.Optional<Value>
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
            }
            """
        )
    }

    // MARK: Set Member Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithSetMemberTypeAndUnconstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value>(parameter: Swift.Set<Value>) -> Swift.Set<Value>
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Swift.Set<AnyHashable>), Swift.Set<AnyHashable>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Swift.Set<AnyHashable>), Swift.Set<AnyHashable>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
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
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func genericMethodWithSetMemberTypeAndConstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value: Equatable>(parameter: Swift.Set<Value>) \
            -> Swift.Set<Value> where Value: Sendable, Value: Comparable & Hashable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Swift.Set<AnyHashable>), Swift.Set<AnyHashable>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Swift.Set<AnyHashable>), Swift.Set<AnyHashable>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
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
            }
            """
        )
    }
}
#endif
