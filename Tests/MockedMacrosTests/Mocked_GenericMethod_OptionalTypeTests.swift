//
//  Mocked_GenericMethod_OptionalTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/12/25.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_GenericMethod_OptionalTypeTests {

    // MARK: Optional Type Tests

    @Test(arguments: testConfigurations)
    func genericMethodWithOptionalTypeAndUnconstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value>(parameter: Value?) -> Value?
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            ((Any)?), (Any)?>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            ((Any)?), (Any)?> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Value>(parameter: Value?) -> Value? {
                    guard
                        let value = self.__method.invoke((parameter)) as? Value?
                    else {
                        fatalError(
                            \"""
                            Unable to cast value returned by \\
                            self._method \\
                            to expected return type Value?.
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
    func genericMethodWithOptionalTypeAndConstrainedGenericParameter(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                func method<Value: Equatable>(parameter: Value?) -> Value? \
            where Value: Sendable, Value: Comparable & Hashable
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                private let __method = MockReturningMethodWithParameters<\
            ((any (Equatable & Sendable & Comparable & Hashable))?), \
            (any (Equatable & Sendable & Comparable & Hashable))?>.makeMethod(
                    exposedMethodDescription: MockImplementationDescription(
                        type: DependencyMock.self,
                        member: "_method"
                    )
                )
                \(mock.memberModifiers)var _method: MockReturningMethodWithParameters<\
            ((any (Equatable & Sendable & Comparable & Hashable))?), \
            (any (Equatable & Sendable & Comparable & Hashable))?> {
                    self.__method.method
                }
                \(mock.memberModifiers)\
            func method<Value: Equatable>(parameter: Value?) -> Value? \
            where Value: Sendable, Value: Comparable & Hashable {
                    guard
                        let value = self.__method.invoke((parameter)) as? Value?
                    else {
                        fatalError(
                            \"""
                            Unable to cast value returned by \\
                            self._method \\
                            to expected return type Value?.
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
