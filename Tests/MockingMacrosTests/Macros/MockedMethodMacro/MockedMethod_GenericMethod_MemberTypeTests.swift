//
//  MockedMethod_GenericMethod_MemberTypeTests.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedMethod_GenericMethod_MemberTypeTests {

    // MARK: Array Member Type Tests

    @Test
    func genericMethodWithArrayMemberTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Swift.Array<Value>) -> Swift.Array<Value>
            """,
            named: "method",
            generates: """
            func method<Value>(parameter: Swift.Array<Value>) -> Swift.Array<Value> {
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
                \tlet returnValue = returnValue as? Swift.Array<Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tSwift.Array<Value>.
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
                typealias Closure = (Swift.Array<Any>) -> ReturnValue

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
                \t_ closure: @Sendable @escaping (Swift.Array<Any>) -> ReturnValue
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
            \t\t(Swift.Array<Any>),
            \t\tSwift.Array<Any>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )

            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Swift.Array<Any>),
            \t\tSwift.Array<Any>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithArrayMemberTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Swift.Array<Value>) -> Swift.Array<Value> \
            where Value: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Value: Equatable>(parameter: Swift.Array<Value>) -> Swift.Array<Value> \
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
                \tlet returnValue = returnValue as? Swift.Array<Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tSwift.Array<Value>.
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
            (Swift.Array<any (Equatable & Sendable & Comparable & Hashable)>) -> ReturnValue

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
            (Swift.Array<any (Equatable & Sendable & Comparable & Hashable)>) -> ReturnValue
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
            \t\t(Swift.Array<any (Equatable & Sendable & Comparable & Hashable)>),
            \t\tSwift.Array<any (Equatable & Sendable & Comparable & Hashable)>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )

            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Swift.Array<any (Equatable & Sendable & Comparable & Hashable)>),
            \t\tSwift.Array<any (Equatable & Sendable & Comparable & Hashable)>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Dictionary Member Type Tests

    @Test
    func genericMethodWithDictionaryMemberTypeAndUnconstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Key, Value>(parameter: Swift.Dictionary<Key, Value>) \
            -> Swift.Dictionary<Key, Value>
            """,
            named: "method",
            generates: """
            func method<Key, Value>(parameter: Swift.Dictionary<Key, Value>) \
            -> Swift.Dictionary<Key, Value> {
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
                \tlet returnValue = returnValue as? Swift.Dictionary<Key, Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tSwift.Dictionary<Key, Value>.
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
                typealias Closure = (Swift.Dictionary<AnyHashable, Any>) -> ReturnValue

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
                \t_ closure: @Sendable @escaping (Swift.Dictionary<AnyHashable, Any>) -> ReturnValue
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
            \t\t(Swift.Dictionary<AnyHashable, Any>),
            \t\tSwift.Dictionary<AnyHashable, Any>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )

            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Swift.Dictionary<AnyHashable, Any>),
            \t\tSwift.Dictionary<AnyHashable, Any>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithDictionaryMemberTypeAndConstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Key: Hashable, Value: Equatable>\
            (parameter: Swift.Dictionary<Key, Value>) -> Swift.Dictionary<Key, Value> \
            where Key: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Key: Hashable, Value: Equatable>\
            (parameter: Swift.Dictionary<Key, Value>) -> Swift.Dictionary<Key, Value> \
            where Key: Sendable, Value: Comparable & Hashable {
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
                \tlet returnValue = returnValue as? Swift.Dictionary<Key, Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tSwift.Dictionary<Key, Value>.
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
            (Swift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>) -> ReturnValue

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
            (Swift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>) -> ReturnValue
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
            \t\t(Swift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>),
            \t\tSwift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )

            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Swift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>),
            \t\tSwift.Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Optional Member Type Tests

    @Test
    func genericMethodWithOptionalMemberTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Swift.Optional<Value>) -> Swift.Optional<Value>
            """,
            named: "method",
            generates: """
            func method<Value>(parameter: Swift.Optional<Value>) -> Swift.Optional<Value> {
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
                \tlet returnValue = returnValue as? Swift.Optional<Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tSwift.Optional<Value>.
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
                typealias Closure = (Swift.Optional<Any>) -> ReturnValue

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
                \t_ closure: @Sendable @escaping (Swift.Optional<Any>) -> ReturnValue
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
            \t\t(Swift.Optional<Any>),
            \t\tSwift.Optional<Any>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )

            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Swift.Optional<Any>),
            \t\tSwift.Optional<Any>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithOptionalMemberTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Swift.Optional<Value>) \
            -> Swift.Optional<Value> where Value: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Value: Equatable>(parameter: Swift.Optional<Value>) \
            -> Swift.Optional<Value> where Value: Sendable, Value: Comparable & Hashable {
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
                \tlet returnValue = returnValue as? Swift.Optional<Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tSwift.Optional<Value>.
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
            (Swift.Optional<any (Equatable & Sendable & Comparable & Hashable)>) -> ReturnValue

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
            (Swift.Optional<any (Equatable & Sendable & Comparable & Hashable)>) -> ReturnValue
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
            \t\t(Swift.Optional<any (Equatable & Sendable & Comparable & Hashable)>),
            \t\tSwift.Optional<any (Equatable & Sendable & Comparable & Hashable)>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )

            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Swift.Optional<any (Equatable & Sendable & Comparable & Hashable)>),
            \t\tSwift.Optional<any (Equatable & Sendable & Comparable & Hashable)>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Set Member Type Tests

    @Test
    func genericMethodWithSetMemberTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Swift.Set<Value>) -> Swift.Set<Value>
            """,
            named: "method",
            generates: """
            func method<Value>(parameter: Swift.Set<Value>) -> Swift.Set<Value> {
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
                \tlet returnValue = returnValue as? Swift.Set<Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tSwift.Set<Value>.
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
                typealias Closure = (Swift.Set<AnyHashable>) -> ReturnValue

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
                \t_ closure: @Sendable @escaping (Swift.Set<AnyHashable>) -> ReturnValue
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
            \t\t(Swift.Set<AnyHashable>),
            \t\tSwift.Set<AnyHashable>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )

            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Swift.Set<AnyHashable>),
            \t\tSwift.Set<AnyHashable>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithSetMemberTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Swift.Set<Value>) -> Swift.Set<Value> \
            where Value: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Value: Equatable>(parameter: Swift.Set<Value>) -> Swift.Set<Value> \
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
                \tlet returnValue = returnValue as? Swift.Set<Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tSwift.Set<Value>.
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
                typealias Closure = (Swift.Set<AnyHashable>) -> ReturnValue

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
                \t_ closure: @Sendable @escaping (Swift.Set<AnyHashable>) -> ReturnValue
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
            \t\t(Swift.Set<AnyHashable>),
            \t\tSwift.Set<AnyHashable>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )

            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Swift.Set<AnyHashable>),
            \t\tSwift.Set<AnyHashable>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
