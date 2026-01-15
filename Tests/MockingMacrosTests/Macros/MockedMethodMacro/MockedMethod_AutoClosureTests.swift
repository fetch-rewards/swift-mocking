//
//  MockedMethod_AutoClosureTests.swift
//
//  Copyright © 2025 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedMethod_AutoClosureTests {

    // MARK: Autoclosure Tests

    @Test
    func autoClosureWithVoidReturnType() {
        assertMockedMethod(
            """
            func method(autoClosure: @escaping @autoclosure () -> Void)
            """,
            named: "method",
            generates: """
            func method(autoClosure: @escaping @autoclosure () -> Void) {
                let autoClosure = autoClosure()
                self.__method.recordInput(
                    (
                        autoClosure
                    )
                )
                let _invoke = self.__method.closure()
                _invoke?(
                    autoClosure
                )
            }

            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedMethodImplementation {

                /// The implementation's closure type.
                typealias Closure = (Void) -> Void

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
                \t_ closure: @Sendable @escaping (Void) -> Void
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
            \t\t(Void)
            \t>
            >.makeMethod()

            var _method: MockVoidParameterizedMethod<
            \tMethodImplementation<
            \t\t(Void)
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func autoClosureWithNonVoidReturnType() {
        assertMockedMethod(
            """
            func method(autoClosure: @escaping @autoclosure () -> Int)
            """,
            named: "method",
            generates: """
            func method(autoClosure: @escaping @autoclosure () -> Int) {
                let autoClosure = autoClosure()
                self.__method.recordInput(
                    (
                        autoClosure
                    )
                )
                let _invoke = self.__method.closure()
                _invoke?(
                    autoClosure
                )
            }

            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedMethodImplementation {

                /// The implementation's closure type.
                typealias Closure = (Int) -> Void

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
                \t_ closure: @Sendable @escaping (Int) -> Void
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
            \t\t(Int)
            \t>
            >.makeMethod()

            var _method: MockVoidParameterizedMethod<
            \tMethodImplementation<
            \t\t(Int)
            \t>
            > {
                self.__method.method
            }
            """
        )
    }

    @Test
    func throwingAutoClosureWithNonVoidReturnType() {
        assertMockedMethod(
            """
            func method(autoClosure: @escaping @autoclosure () throws -> Int)
            """,
            named: "method",
            generates: """
            func method(autoClosure: @escaping @autoclosure () throws -> Int) {
                let autoClosure = autoClosure()
                do {
                    self = .success(try await body())
                } catch {
                    self = .failure(error)
                }
                self.__method.recordInput(
                    (
                        autoClosure
                    )
                )
                let _invoke = self.__method.closure()
                _invoke?(
                    autoClosure
                )
            }

            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedMethodImplementation {

                /// The implementation's closure type.
                typealias Closure = (Result<Int, any Error>) -> Void

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
                \t_ closure: @Sendable @escaping (Int) -> Void
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
            \t\t(Int)
            \t>
            >.makeMethod()

            var _method: MockVoidParameterizedMethod<
            \tMethodImplementation<
            \t\t(Int)
            \t>
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
