//
//  Mocked_GenericMethod_IdentifierTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/12/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_GenericMethod_IdentifierTypeTests {

    // MARK: Array Identifier Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithArrayIdentifierTypeAndUnconstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value>(parameter: Array<Value>) -> Array<Value>
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Array<Any>), Array<Any>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Array<Any>), Array<Any>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
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
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func genericMethodWithArrayIdentifierTypeAndConstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value: Equatable>(parameter: Array<Value>) -> Array<Value> \
            where Value: Sendable, Value: Comparable & Hashable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Array<any (Equatable & Sendable & Comparable & Hashable)>), \
            Array<any (Equatable & Sendable & Comparable & Hashable)>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Array<any (Equatable & Sendable & Comparable & Hashable)>), \
            Array<any (Equatable & Sendable & Comparable & Hashable)>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
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
            }
            """
        )
    }

    // MARK: Dictionary Identifier Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithDictionaryIdentifierTypeAndUnconstrainedGenericParameters(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Key, Value>(parameter: Dictionary<Key, Value>) \
            -> Dictionary<Key, Value>
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Dictionary<AnyHashable, Any>), Dictionary<AnyHashable, Any>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Dictionary<AnyHashable, Any>), Dictionary<AnyHashable, Any>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
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
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func genericMethodWithDictionaryIdentifierTypeAndConstrainedGenericParameters(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Key: Hashable, Value: Equatable>\
            (parameter: Dictionary<Key, Value>) -> Dictionary<Key, Value> \
            where Key: Sendable, Value: Comparable & Hashable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>), \
            Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>), \
            Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
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
            }
            """
        )
    }

    // MARK: Optional Identifier Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithOptionalIdentifierTypeAndUnconstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value>(parameter: Optional<Value>) -> Optional<Value>
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Optional<Any>), Optional<Any>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Optional<Any>), Optional<Any>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
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
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func genericMethodWithOptionalIdentifierTypeAndConstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value: Equatable>(parameter: Optional<Value>) -> Optional<Value> \
            where Value: Sendable, Value: Comparable & Hashable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Optional<any (Equatable & Sendable & Comparable & Hashable)>), \
            Optional<any (Equatable & Sendable & Comparable & Hashable)>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Optional<any (Equatable & Sendable & Comparable & Hashable)>), \
            Optional<any (Equatable & Sendable & Comparable & Hashable)>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Value: Equatable>(parameter: Optional<Value>) -> Optional<Value> \
            where Value: Sendable, Value: Comparable & Hashable {
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
            }
            """
        )
    }

    // MARK: Set Identifier Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithSetIdentifierTypeAndUnconstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value>(parameter: Set<Value>) -> Set<Value>
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Set<AnyHashable>), Set<AnyHashable>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Set<AnyHashable>), Set<AnyHashable>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
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
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func genericMethodWithSetIdentifierTypeAndConstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value: Equatable>(parameter: Set<Value>) -> Set<Value> \
            where Value: Sendable, Value: Comparable & Hashable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            (Set<AnyHashable>), Set<AnyHashable>>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            (Set<AnyHashable>), Set<AnyHashable>> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
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
            }
            """
        )
    }
}
#endif
