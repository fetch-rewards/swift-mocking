//
//  Mocked_GenericMethod_DictionaryTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/11/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_GenericMethod_DictionaryTypeTests {

    // MARK: Dictionary Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithDictionaryTypeAndUnconstrainedGenericParameters(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Key, Value>(parameter: [Key: Value]) -> [Key: Value]
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            ([AnyHashable: Any]), [AnyHashable: Any]>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            ([AnyHashable: Any]), [AnyHashable: Any]> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Key, Value>(parameter: [Key: Value]) -> [Key: Value] {
                    guard
                        let value = self.__method.invoke((parameter)) as? [Key: Value]
                    else {
                        fatalError(
                            \"""
                            Unable to cast value returned by \\
                            self._method \\
                            to expected return type [Key: Value].
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
    func genericMethodWithDictionaryTypeAndConstrainedGenericParameters(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Key: Hashable, Value: Equatable>(parameter: [Key: Value]) \
            -> [Key: Value] where Key: Sendable, Value: Comparable & Hashable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            ([AnyHashable: any (Equatable & Comparable & Hashable)]), \
            [AnyHashable: any (Equatable & Comparable & Hashable)]>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            ([AnyHashable: any (Equatable & Comparable & Hashable)]), \
            [AnyHashable: any (Equatable & Comparable & Hashable)]> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Key: Hashable, Value: Equatable>(parameter: [Key: Value]) \
            -> [Key: Value] where Key: Sendable, Value: Comparable & Hashable {
                    guard
                        let value = self.__method.invoke((parameter)) as? [Key: Value]
                    else {
                        fatalError(
                            \"""
                            Unable to cast value returned by \\
                            self._method \\
                            to expected return type [Key: Value].
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
