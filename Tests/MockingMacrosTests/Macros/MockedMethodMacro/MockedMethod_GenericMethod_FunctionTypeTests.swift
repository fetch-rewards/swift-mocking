//
//  MockedMethod_GenericMethod_FunctionTypeTests.swift
//  MockingMacrosTests
//
//  Created by Gray Campbell on 1/11/25.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedMethod_GenericMethod_FunctionTypeTests {

    // MARK: Function Type Tests

    @Test
    func genericMethodWithFunctionTypeAndUnconstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Value>(parameter: @escaping (String) -> Value) \
            -> (String) -> Value
            """,
            named: "method",
            generates: """
            func method<Value>(parameter: @escaping (String) -> Value) \
            -> (String) -> Value {
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
                \tlet returnValue = returnValue as? (String) -> Value
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \t(String) -> Value.
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
                typealias Closure = ((String) -> Any) -> ReturnValue

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
                \t_ closure: @Sendable @escaping ((String) -> Any) -> ReturnValue
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
            \t\t((String) -> Any),
            \t\t(String) -> Any
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t((String) -> Any),
            \t\t(String) -> Any
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithFunctionTypeAndConstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Value: Sendable>(parameter: @escaping (String) -> Value) \
            -> (String) -> Value where Value: Equatable
            """,
            named: "method",
            generates: """
            func method<Value: Sendable>(parameter: @escaping (String) -> Value) \
            -> (String) -> Value where Value: Equatable {
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
                \tlet returnValue = returnValue as? (String) -> Value
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \t(String) -> Value.
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
            ((String) -> any (Sendable & Equatable)) -> ReturnValue

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
            ((String) -> any (Sendable & Equatable)) -> ReturnValue
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
            \t\t((String) -> any (Sendable & Equatable)),
            \t\t(String) -> any (Sendable & Equatable)
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t((String) -> any (Sendable & Equatable)),
            \t\t(String) -> any (Sendable & Equatable)
            \t>
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
