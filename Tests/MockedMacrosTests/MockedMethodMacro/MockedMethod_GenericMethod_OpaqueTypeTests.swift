//
//  MockedMethod_GenericMethod_OpaqueTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/11/25.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct MockedMethod_GenericMethod_OpaqueTypeTests {

    // MARK: Opaque Type Tests

    @Test
    func genericMethodWithOpaqueTypeWithOneConstraint() {
        assertMockedMethod(
            """
            func method(parameter: some Equatable)
            """,
            named: "method",
            generates: """
            func method(parameter: some Equatable) {
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
                typealias Closure = (any Equatable) -> Void

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
                \t_ closure: @Sendable @escaping (any Equatable) -> Void
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
            \t\t(any Equatable)
            \t>
            >.makeMethod()
            
            var _method: MockVoidParameterizedMethod<
            \tMethodImplementation<
            \t\t(any Equatable)
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func genericMethodWithOpaqueTypeWithMultipleConstraints() {
        assertMockedMethod(
            """
            func method(parameter: some Equatable & Sendable & Comparable)
            """,
            named: "method",
            generates: """
            func method(parameter: some Equatable & Sendable & Comparable) {
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
                typealias Closure = (any (Equatable & Sendable & Comparable)) -> Void

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
                \t_ closure: @Sendable @escaping (any (Equatable & Sendable & Comparable)) -> Void
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
            \t\t(any (Equatable & Sendable & Comparable))
            \t>
            >.makeMethod()
            
            var _method: MockVoidParameterizedMethod<
            \tMethodImplementation<
            \t\t(any (Equatable & Sendable & Comparable))
            \t>
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
