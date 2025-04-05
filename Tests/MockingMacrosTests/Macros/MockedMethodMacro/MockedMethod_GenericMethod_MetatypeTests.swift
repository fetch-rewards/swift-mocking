//
//  MockedMethod_GenericMethod_MetatypeTests.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedMethod_GenericMethod_MetatypeTests {

    // MARK: Generic Type Metatype Tests

    @Test
    func genericMethodWithGenericTypeMetatypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Value.Type) -> Value.Type
            """,
            named: "method",
            generates: """
            func method<Value>(parameter: Value.Type) -> Value.Type {
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
                \tlet returnValue = returnValue as? Value.Type
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tValue.Type.
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
                typealias Closure = (Any.Type) -> ReturnValue

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
                \t_ closure: @Sendable @escaping (Any.Type) -> ReturnValue
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
            \t\t(Any.Type),
            \t\tAny.Type
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Any.Type),
            \t\tAny.Type
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithGenericTypeMetatypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Value.Type) -> Value.Type \
            where Value: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Value: Equatable>(parameter: Value.Type) -> Value.Type \
            where Value: Sendable, Value: Comparable & Hashable {
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
                \tlet returnValue = returnValue as? Value.Type
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tValue.Type.
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
            (any (Equatable & Sendable & Comparable & Hashable).Type) -> ReturnValue

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
            (any (Equatable & Sendable & Comparable & Hashable).Type) -> ReturnValue
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
            \t\t(any (Equatable & Sendable & Comparable & Hashable).Type),
            \t\tany (Equatable & Sendable & Comparable & Hashable).Type
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(any (Equatable & Sendable & Comparable & Hashable).Type),
            \t\tany (Equatable & Sendable & Comparable & Hashable).Type
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Opaque Type Metatype Tests

    @Test
    func genericMethodWithOpaqueTypeMetatypeWithOneConstraint() {
        assertMockedMethod(
            """
            func method(parameter: (some Equatable).Type)
            """,
            named: "method",
            generates: """
            func method(parameter: (some Equatable).Type) {
                self.__method.recordInput(
                    (
                        parameter
                    )
                )
                let _invoke = self.__method.closure()
                _invoke?(
                    parameter
                )
            }
            
            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedMethodImplementation {

                /// The implementation's closure type.
                typealias Closure = (any Equatable.Type) -> Void

                /// Does nothing when invoked.
                case unimplemented

                /// Invokes the provided closure when invoked.
                ///
                /// - Parameter closure: The closure to invoke.
                case uncheckedInvokes(_ closure: Closure)

                /// Invokes the provided closure when invoked.
                ///
                /// - Parameter closure: The closure to invoke.
                static func invokes(
                \t_ closure: @Sendable @escaping (any Equatable.Type) -> Void
                ) -> Self where Arguments: Sendable {
                    .uncheckedInvokes(closure)
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
            
            private let __method = MockVoidParameterizedMethod<
            \tMethodImplementation<
            \t\t(any Equatable.Type)
            \t>
            >.makeMethod()
            
            var _method: MockVoidParameterizedMethod<
            \tMethodImplementation<
            \t\t(any Equatable.Type)
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithOpaqueTypeMetatypeWithMultipleConstraints() {
        assertMockedMethod(
            """
            func method(parameter: (some Equatable & Sendable & Comparable).Type)
            """,
            named: "method",
            generates: """
            func method(parameter: (some Equatable & Sendable & Comparable).Type) {
                self.__method.recordInput(
                    (
                        parameter
                    )
                )
                let _invoke = self.__method.closure()
                _invoke?(
                    parameter
                )
            }
            
            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedMethodImplementation {

                /// The implementation's closure type.
                typealias Closure = (any (Equatable & Sendable & Comparable).Type) -> Void

                /// Does nothing when invoked.
                case unimplemented

                /// Invokes the provided closure when invoked.
                ///
                /// - Parameter closure: The closure to invoke.
                case uncheckedInvokes(_ closure: Closure)

                /// Invokes the provided closure when invoked.
                ///
                /// - Parameter closure: The closure to invoke.
                static func invokes(
                \t_ closure: @Sendable @escaping (any (Equatable & Sendable & Comparable).Type) -> Void
                ) -> Self where Arguments: Sendable {
                    .uncheckedInvokes(closure)
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
            
            private let __method = MockVoidParameterizedMethod<
            \tMethodImplementation<
            \t\t(any (Equatable & Sendable & Comparable).Type)
            \t>
            >.makeMethod()
            
            var _method: MockVoidParameterizedMethod<
            \tMethodImplementation<
            \t\t(any (Equatable & Sendable & Comparable).Type)
            \t>
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
