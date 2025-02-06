//
//  MockedMethod_GenericMethod_DictionaryTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/11/25.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct Mocked_GenericMethod_DictionaryTypeTests {

    // MARK: Dictionary Type Tests

    @Test
    func genericMethodWithDictionaryTypeAndUnconstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Key, Value>(parameter: [Key: Value]) -> [Key: Value]
            """,
            named: "method",
            generates: """
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
            
            private let __method = MockReturningMethodWithParameters<
            \t([AnyHashable: Any]),
            \t[AnyHashable: Any]
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t([AnyHashable: Any]),
            \t[AnyHashable: Any]
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithDictionaryTypeAndConstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Key: Hashable, Value: Equatable>(parameter: [Key: Value]) \
            -> [Key: Value] where Key: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
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
            
            private let __method = MockReturningMethodWithParameters<
            \t([AnyHashable: any (Equatable & Comparable & Hashable)]),
            \t[AnyHashable: any (Equatable & Comparable & Hashable)]
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningMethodWithParameters<
            \t([AnyHashable: any (Equatable & Comparable & Hashable)]),
            \t[AnyHashable: any (Equatable & Comparable & Hashable)]
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
