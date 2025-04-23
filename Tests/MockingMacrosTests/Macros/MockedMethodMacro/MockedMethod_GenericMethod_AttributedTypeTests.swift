//
//  MockedMethod_GenericMethod_AttributedTypeTests.swift
//  MockingMacrosTests
//
//  Created by Gray Campbell on 1/10/25.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedMethod_GenericMethod_AttributedTypeTests {

    // MARK: Attributed Type Tests

    @Test
    func genericMethodWithAttributedTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: inout Value)
            """,
            named: "method",
            generates: """
            func method<Value>(parameter: inout Value) {
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
                typealias Closure = (Any) -> Void

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
                \t_ closure: @Sendable @escaping (Any) -> Void
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
            \t\t(Any)
            \t>
            >.makeMethod()
            
            var _method: MockVoidParameterizedMethod<
            \tMethodImplementation<
            \t\t(Any)
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithAttributedTypeAndConstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value: Equatable>(parameter: inout Value) \
            where Value: Sendable, Value: Comparable & Hashable
            """,
            named: "method",
            generates: """
            func method<Value: Equatable>(parameter: inout Value) \
            where Value: Sendable, Value: Comparable & Hashable {
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
                typealias Closure = \
            (any (Equatable & Sendable & Comparable & Hashable)) -> Void

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
                \t_ closure: @Sendable @escaping \
            (any (Equatable & Sendable & Comparable & Hashable)) -> Void
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
            \t\t(any (Equatable & Sendable & Comparable & Hashable))
            \t>
            >.makeMethod()
            
            var _method: MockVoidParameterizedMethod<
            \tMethodImplementation<
            \t\t(any (Equatable & Sendable & Comparable & Hashable))
            \t>
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
