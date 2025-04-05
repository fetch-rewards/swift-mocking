//
//  MockedMethod_GenericMethod_IdentifierTypeTests.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedMethod_GenericMethod_IdentifierTypeTests {

    // MARK: Array Identifier Type Tests

    @Test
    func genericMethodWithArrayIdentifierTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Array<Value>) -> Array<Value>
            """,
            named: "method",
            generates: """
            func method<Value>(parameter: Array<Value>) -> Array<Value> {
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
                \tlet returnValue = returnValue as? Array<Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tArray<Value>.
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
                typealias Closure = (Array<Any>) -> ReturnValue

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
                \t_ closure: @Sendable @escaping (Array<Any>) -> ReturnValue
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
            \t\t(Array<Any>),
            \t\tArray<Any>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Array<Any>),
            \t\tArray<Any>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithArrayIdentifierTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Array<Value>) -> Array<Value> \
            where Value: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Value: Equatable>(parameter: Array<Value>) -> Array<Value> \
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
                \tlet returnValue = returnValue as? Array<Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tArray<Value>.
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
            (Array<any (Equatable & Sendable & Comparable & Hashable)>) -> ReturnValue

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
            (Array<any (Equatable & Sendable & Comparable & Hashable)>) -> ReturnValue
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
            \t\t(Array<any (Equatable & Sendable & Comparable & Hashable)>),
            \t\tArray<any (Equatable & Sendable & Comparable & Hashable)>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Array<any (Equatable & Sendable & Comparable & Hashable)>),
            \t\tArray<any (Equatable & Sendable & Comparable & Hashable)>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Dictionary Identifier Type Tests

    @Test
    func genericMethodWithDictionaryIdentifierTypeAndUnconstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Key, Value>(parameter: Dictionary<Key, Value>) \
            -> Dictionary<Key, Value>
            """,
            named: "method",
            generates: """
            func method<Key, Value>(parameter: Dictionary<Key, Value>) \
            -> Dictionary<Key, Value> {
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
                \tlet returnValue = returnValue as? Dictionary<Key, Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tDictionary<Key, Value>.
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
                typealias Closure = (Dictionary<AnyHashable, Any>) -> ReturnValue

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
                \t_ closure: @Sendable @escaping (Dictionary<AnyHashable, Any>) -> ReturnValue
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
            \t\t(Dictionary<AnyHashable, Any>),
            \t\tDictionary<AnyHashable, Any>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Dictionary<AnyHashable, Any>),
            \t\tDictionary<AnyHashable, Any>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithDictionaryIdentifierTypeAndConstrainedGenericParameters() {
        assertMockedMethod(
            """
            func method<Key: Hashable, Value: Equatable>\
            (parameter: Dictionary<Key, Value>) -> Dictionary<Key, Value> \
            where Key: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Key: Hashable, Value: Equatable>\
            (parameter: Dictionary<Key, Value>) -> Dictionary<Key, Value> \
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
                \tlet returnValue = returnValue as? Dictionary<Key, Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tDictionary<Key, Value>.
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
            (Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>) -> ReturnValue

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
            (Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>) -> ReturnValue
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
            \t\t(Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>),
            \t\tDictionary<AnyHashable, any (Equatable & Comparable & Hashable)>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Dictionary<AnyHashable, any (Equatable & Comparable & Hashable)>),
            \t\tDictionary<AnyHashable, any (Equatable & Comparable & Hashable)>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Optional Identifier Type Tests

    @Test
    func genericMethodWithOptionalIdentifierTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Optional<Value>) -> Optional<Value>
            """,
            named: "method",
            generates: """
            func method<Value>(parameter: Optional<Value>) -> Optional<Value> {
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
                \tlet returnValue = returnValue as? Optional<Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tOptional<Value>.
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
                typealias Closure = (Optional<Any>) -> ReturnValue

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
                \t_ closure: @Sendable @escaping (Optional<Any>) -> ReturnValue
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
            \t\t(Optional<Any>),
            \t\tOptional<Any>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Optional<Any>),
            \t\tOptional<Any>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithOptionalIdentifierTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Optional<Value>) \
            -> Optional<Value> where Value: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Value: Equatable>(parameter: Optional<Value>) \
            -> Optional<Value> where Value: Sendable, Value: Comparable & Hashable {
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
                \tlet returnValue = returnValue as? Optional<Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tOptional<Value>.
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
            (Optional<any (Equatable & Sendable & Comparable & Hashable)>) -> ReturnValue

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
            (Optional<any (Equatable & Sendable & Comparable & Hashable)>) -> ReturnValue
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
            \t\t(Optional<any (Equatable & Sendable & Comparable & Hashable)>),
            \t\tOptional<any (Equatable & Sendable & Comparable & Hashable)>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Optional<any (Equatable & Sendable & Comparable & Hashable)>),
            \t\tOptional<any (Equatable & Sendable & Comparable & Hashable)>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    // MARK: Set Identifier Type Tests

    @Test
    func genericMethodWithSetIdentifierTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: Set<Value>) -> Set<Value>
            """,
            named: "method",
            generates: """
            func method<Value>(parameter: Set<Value>) -> Set<Value> {
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
                \tlet returnValue = returnValue as? Set<Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tSet<Value>.
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
                typealias Closure = (Set<AnyHashable>) -> ReturnValue

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
                \t_ closure: @Sendable @escaping (Set<AnyHashable>) -> ReturnValue
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
            \t\t(Set<AnyHashable>),
            \t\tSet<AnyHashable>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Set<AnyHashable>),
            \t\tSet<AnyHashable>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithSetIdentifierTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: Set<Value>) -> Set<Value> \
            where Value: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Value: Equatable>(parameter: Set<Value>) -> Set<Value> \
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
                \tlet returnValue = returnValue as? Set<Value>
                else {
                    fatalError(
                    \t\"""
                    \tUnable to cast value returned by \\
                    \tself._method \\
                    \tto expected return type \\
                    \tSet<Value>.
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
                typealias Closure = (Set<AnyHashable>) -> ReturnValue

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
                \t_ closure: @Sendable @escaping (Set<AnyHashable>) -> ReturnValue
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
            \t\t(Set<AnyHashable>),
            \t\tSet<AnyHashable>
            \t>
            >.makeMethod(
                exposedMethodDescription: MockImplementationDescription(
                    type: DependencyMock.self,
                    member: "_method"
                )
            )
            
            var _method: MockReturningParameterizedMethod<
            \tMethodImplementation<
            \t\t(Set<AnyHashable>),
            \t\tSet<AnyHashable>
            \t>
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
