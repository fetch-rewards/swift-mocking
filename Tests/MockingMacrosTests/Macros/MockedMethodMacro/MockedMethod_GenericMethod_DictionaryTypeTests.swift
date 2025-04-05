//
//  MockedMethod_GenericMethod_DictionaryTypeTests.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

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
                self.__method.recordInput(
                    (
                        parameter
                    )
                )
                let _invoke = self.__method.closure()
                let returnValue = _invoke(
                    parameter
                )
                guard
                \tlet returnValue = returnValue as? [Key: Value]
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \t[Key: Value].
                    \t\"""
                    )
                }
                self.__method.recordOutput(
                    returnValue
                )
                return returnValue
            }

            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments,
            \tReturnValue
            >: @unchecked Sendable, MockReturningParameterizedMethodImplementation {

                /// The implementation's closure type.
                typealias Closure = ([AnyHashable: Any]) -> ReturnValue

                /// Triggers a fatal error when invoked.
                case unimplemented

                /// Invokes the provided closure when invoked.
                ///
                /// - Parameter closure: The closure to invoke.
                case uncheckedInvokes(_ closure: Closure)

                /// Invokes the provided closure when invoked.
                ///
                /// - Parameter closure: The closure to invoke.
                static func invokes(
                \t_ closure: @Sendable @escaping ([AnyHashable: Any]) -> ReturnValue
                ) -> Self where Arguments: Sendable, ReturnValue: Sendable {
                    .uncheckedInvokes(closure)
                }

                /// Returns the provided value when invoked.
                ///
                /// - Parameter value: The value to return.
                static func uncheckedReturns(
                \t_ value: ReturnValue
                ) -> Self {
                    .uncheckedInvokes { _ in
                        value
                    }
                }

                /// Returns the provided value when invoked.
                ///
                /// - Parameter value: The value to return.
                static func returns(
                \t_ value: ReturnValue
                ) -> Self where ReturnValue: Sendable {
                    .uncheckedInvokes { _ in
                        value
                    }
                }

                /// The implementation as a closure, or `nil` if unimplemented.
                var _closure: Closure? {
                    switch self {
                    case .unimplemented:
                        nil
                    case let .uncheckedInvokes(closure):
                        closure
                    }
                }
            }

            private let __method = MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t([AnyHashable: Any]),
            \t\t[AnyHashable: Any]
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )

            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t([AnyHashable: Any]),
            \t\t[AnyHashable: Any]
            \t>
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
                self.__method.recordInput(
                    (
                        parameter
                    )
                )
                let _invoke = self.__method.closure()
                let returnValue = _invoke(
                    parameter
                )
                guard
                \tlet returnValue = returnValue as? [Key: Value]
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \t[Key: Value].
                    \t\"""
                    )
                }
                self.__method.recordOutput(
                    returnValue
                )
                return returnValue
            }

            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments,
            \tReturnValue
            >: @unchecked Sendable, MockReturningParameterizedMethodImplementation {

                /// The implementation's closure type.
                typealias Closure = \
            ([AnyHashable: any (Equatable & Comparable & Hashable)]) -> ReturnValue

                /// Triggers a fatal error when invoked.
                case unimplemented

                /// Invokes the provided closure when invoked.
                ///
                /// - Parameter closure: The closure to invoke.
                case uncheckedInvokes(_ closure: Closure)

                /// Invokes the provided closure when invoked.
                ///
                /// - Parameter closure: The closure to invoke.
                static func invokes(
                \t_ closure: @Sendable @escaping \
            ([AnyHashable: any (Equatable & Comparable & Hashable)]) -> ReturnValue
                ) -> Self where Arguments: Sendable, ReturnValue: Sendable {
                    .uncheckedInvokes(closure)
                }

                /// Returns the provided value when invoked.
                ///
                /// - Parameter value: The value to return.
                static func uncheckedReturns(
                \t_ value: ReturnValue
                ) -> Self {
                    .uncheckedInvokes { _ in
                        value
                    }
                }

                /// Returns the provided value when invoked.
                ///
                /// - Parameter value: The value to return.
                static func returns(
                \t_ value: ReturnValue
                ) -> Self where ReturnValue: Sendable {
                    .uncheckedInvokes { _ in
                        value
                    }
                }

                /// The implementation as a closure, or `nil` if unimplemented.
                var _closure: Closure? {
                    switch self {
                    case .unimplemented:
                        nil
                    case let .uncheckedInvokes(closure):
                        closure
                    }
                }
            }

            private let __method = MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t([AnyHashable: any (Equatable & Comparable & Hashable)]),
            \t\t[AnyHashable: any (Equatable & Comparable & Hashable)]
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )

            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t([AnyHashable: any (Equatable & Comparable & Hashable)]),
            \t\t[AnyHashable: any (Equatable & Comparable & Hashable)]
            \t>
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
