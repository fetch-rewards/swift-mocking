//
//  MockedMethod_GenericMethod_TupleTypeTests.swift
//  MockingMacrosTests
//
//  Created by Gray Campbell on 1/11/25.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedMethod_GenericMethod_TupleTypeTests {

    // MARK: Tuple Type Tests

    @Test
    func genericMethodWithTupleTypeAndUnconstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Value1, Value2>(parameter: (Value1, Value2)) \
            -> (Value1, Value2)
            """,
            named: "method",
            generates: """
            func method<Value1, Value2>(parameter: (Value1, Value2)) \
            -> (Value1, Value2) {
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
                \tlet returnValue = returnValue as? (Value1, Value2)
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \t(Value1, Value2).
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
                typealias Closure = ((Any, Any)) -> ReturnValue

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
                \t_ closure: @Sendable @escaping ((Any, Any)) -> ReturnValue
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
            \t\t((Any, Any)),
            \t\t(Any, Any)
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t((Any, Any)),
            \t\t(Any, Any)
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithTupleTypeAndConstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Value1: Equatable, Value2: Hashable>\
            (parameter: (Value1, Value2)) -> (Value1, Value2) \
            where Value1: Sendable, Value2: Comparable
            """,
            named: "method",
            generates: """
            func method<Value1: Equatable, Value2: Hashable>\
            (parameter: (Value1, Value2)) -> (Value1, Value2) \
            where Value1: Sendable, Value2: Comparable {
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
                \tlet returnValue = returnValue as? (Value1, Value2)
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \t(Value1, Value2).
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
            ((any (Equatable & Sendable), any (Hashable & Comparable))) -> ReturnValue

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
            ((any (Equatable & Sendable), any (Hashable & Comparable))) -> ReturnValue
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
            \t\t((any (Equatable & Sendable), any (Hashable & Comparable))),
            \t\t(any (Equatable & Sendable), any (Hashable & Comparable))
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t((any (Equatable & Sendable), any (Hashable & Comparable))),
            \t\t(any (Equatable & Sendable), any (Hashable & Comparable))
            \t>
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
