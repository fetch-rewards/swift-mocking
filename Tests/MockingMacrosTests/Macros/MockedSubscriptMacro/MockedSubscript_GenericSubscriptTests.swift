//
//  MockedSubscript_GenericSubscriptTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedSubscript_GenericSubscriptTests {

    // MARK: Array Identifier Type Tests

    @Test
    func genericReadOnlySubscriptWithArrayIdentifierTypeAndUnconstrainedGenericParameter() {
        assertMockedSubscript(
            """
            subscript<Value>(key: String) -> Array<Value>
            """,
            ofType: ".readOnly",
            named: "subscriptKey",
            generates: """
            subscript<Value>(key: String) -> Array<Value> {
                get {
                    let returnValue = self.__subscriptKey.get(key)
                    guard
                    \tlet returnValue = returnValue as? Array<Value>
                    else {
                        fatalError(
                        \t\"""
                        \tUnable to cast value returned by \\
                        \tself._subscriptKey \\
                        \tto expected return type \\
                        \tArray<Value>.
                        \t\"""
                        )
                    }
                    return returnValue
                }
            }

            private let __subscriptKey = MockReadOnlySubscript<
            \tString,
            \tArray<Any>
            >.makeSubscript(
                exposedSubscriptDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_subscriptKey"
                )
            )

            var _subscriptKey: MockReadOnlySubscript<
            \tString,
            \tArray<Any>
            > {
                self.__subscriptKey.`subscript`
            }
            """
        )
    }

    @Test
    func genericReadOnlySubscriptWithArrayIdentifierTypeAndConstrainedGenericParameter() {
        assertMockedSubscript(
            """
            subscript<Value: Equatable>(key: String) -> Array<Value> \
            where Value: Sendable, Value: Comparable & Hashable
            """,
            ofType: ".readOnly",
            named: "subscriptKey",
            generates: """
            subscript<Value: Equatable>(key: String) -> Array<Value> \
            where Value: Sendable, Value: Comparable & Hashable {
                get {
                    let returnValue = self.__subscriptKey.get(key)
                    guard
                    \tlet returnValue = returnValue as? Array<Value>
                    else {
                        fatalError(
                        \t\"""
                        \tUnable to cast value returned by \\
                        \tself._subscriptKey \\
                        \tto expected return type \\
                        \tArray<Value>.
                        \t\"""
                        )
                    }
                    return returnValue
                }
            }

            private let __subscriptKey = MockReadOnlySubscript<
            \tString,
            \tArray<any (Equatable & Sendable & Comparable & Hashable)>
            >.makeSubscript(
                exposedSubscriptDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_subscriptKey"
                )
            )

            var _subscriptKey: MockReadOnlySubscript<
            \tString,
            \tArray<any (Equatable & Sendable & Comparable & Hashable)>
            > {
                self.__subscriptKey.`subscript`
            }
            """
        )
    }

    // MARK: Read-Write Generic Subscript Tests

    @Test
    func genericReadWriteSubscriptWithArrayIdentifierTypeAndUnconstrainedGenericParameter() {
        assertMockedSubscript(
            """
            subscript<Value>(key: String) -> Array<Value>
            """,
            ofType: ".readWrite",
            named: "subscriptKey",
            generates: """
            subscript<Value>(key: String) -> Array<Value> {
                get {
                    let returnValue = self.__subscriptKey.get(key)
                    guard
                    \tlet returnValue = returnValue as? Array<Value>
                    else {
                        fatalError(
                        \t\"""
                        \tUnable to cast value returned by \\
                        \tself._subscriptKey \\
                        \tto expected return type \\
                        \tArray<Value>.
                        \t\"""
                        )
                    }
                    return returnValue
                }
                set {
                    self.__subscriptKey.set(key, newValue)
                }
            }

            private let __subscriptKey = MockReadWriteSubscript<
            \tString,
            \tArray<Any>
            >.makeSubscript(
                exposedSubscriptDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_subscriptKey"
                )
            )

            var _subscriptKey: MockReadWriteSubscript<
            \tString,
            \tArray<Any>
            > {
                self.__subscriptKey.`subscript`
            }
            """
        )
    }
}
#endif
