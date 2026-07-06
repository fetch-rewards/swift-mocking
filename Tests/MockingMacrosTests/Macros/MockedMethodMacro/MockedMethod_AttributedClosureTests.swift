//
//  MockedMethod_AttributedClosureTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedMethod_AttributedClosureTests {

    // MARK: Attributed Closure Tests

    @Test
    func sendableClosureParameter() {
        assertMockedMethod(
            """
            func something(work: @escaping @Sendable () -> Void)
            """,
            named: "something",
            generates: """
            func something(work: @escaping @Sendable () -> Void) {
                self.__something.recordInput(
                    (
                        work
                    )
                )
                let _invoke = self.__something.closure()
                _invoke?(
                    work
                )
            }

            /// An implementation for `DependencyMock._something`.
            enum SomethingImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedMethodImplementation {

                /// The implementation's closure type.
                typealias Closure = (@escaping @Sendable () -> Void) -> Void

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
                \t_ closure: @Sendable @escaping (@escaping @Sendable () -> Void) -> Void
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

            private let __something = MockVoidParameterizedMethod<
            \tSomethingImplementation<
            \t\t(@Sendable () -> Void)
            \t>
            >.makeMethod()

            var _something: MockVoidParameterizedMethod<
            \tSomethingImplementation<
            \t\t(@Sendable () -> Void)
            \t>
            > {
                self.__something.method
            }
            """
        )
    }

    @Test
    func mainActorSendableClosureParameter() {
        assertMockedMethod(
            """
            func something(work: @escaping @MainActor @Sendable () -> Void)
            """,
            named: "something",
            generates: """
            func something(work: @escaping @MainActor @Sendable () -> Void) {
                self.__something.recordInput(
                    (
                        work
                    )
                )
                let _invoke = self.__something.closure()
                _invoke?(
                    work
                )
            }

            /// An implementation for `DependencyMock._something`.
            enum SomethingImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedMethodImplementation {

                /// The implementation's closure type.
                typealias Closure = (@escaping @MainActor @Sendable () -> Void) -> Void

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
                \t_ closure: @Sendable @escaping (@escaping @MainActor @Sendable () -> Void) -> Void
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

            private let __something = MockVoidParameterizedMethod<
            \tSomethingImplementation<
            \t\t(@MainActor @Sendable () -> Void)
            \t>
            >.makeMethod()

            var _something: MockVoidParameterizedMethod<
            \tSomethingImplementation<
            \t\t(@MainActor @Sendable () -> Void)
            \t>
            > {
                self.__something.method
            }
            """
        )
    }

    @Test
    func consumingSendableClosureParameter() {
        assertMockedMethod(
            """
            func something(work: consuming @Sendable () -> Void)
            """,
            named: "something",
            generates: """
            func something(work: consuming @Sendable () -> Void) {
                let work = work
                self.__something.recordInput(
                    (
                        work
                    )
                )
                let _invoke = self.__something.closure()
                _invoke?(
                    work
                )
            }

            /// An implementation for `DependencyMock._something`.
            enum SomethingImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedMethodImplementation {

                /// The implementation's closure type.
                typealias Closure = (consuming @Sendable () -> Void) -> Void

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
                \t_ closure: @Sendable @escaping (consuming @Sendable () -> Void) -> Void
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

            private let __something = MockVoidParameterizedMethod<
            \tSomethingImplementation<
            \t\t(@Sendable () -> Void)
            \t>
            >.makeMethod()

            var _something: MockVoidParameterizedMethod<
            \tSomethingImplementation<
            \t\t(@Sendable () -> Void)
            \t>
            > {
                self.__something.method
            }
            """
        )
    }
}
#endif
