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
    func asyncAutoClosureWithVoidReturnType() {
        assertMockedMethod(
            """
            func method(autoClosure: @escaping @autoclosure () async -> Void) async
            """,
            named: "method",
            generates: """
            func method(autoClosure: @escaping @autoclosure () async -> Void) async {
                let autoClosure = await autoClosure()
                self.__method.recordInput(
                    (
                        autoClosure
                    )
                )
                let _invoke = self.__method.closure()
                await _invoke?(
                    autoClosure
                )
            }

            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedAsyncMethodImplementation {

            \t/// The implementation's closure type.
            \ttypealias Closure = (Void) async -> Void

            \t/// Does nothing when invoked.
            \tcase unimplemented

            \t/// Invokes the provided closure when invoked.
            \t///
            \t/// - Parameter closure: The closure to invoke.
            \tcase uncheckedInvokes(_ closure: Closure)

            \t/// Invokes the provided closure when invoked.
            \t///
            \t/// - Parameter closure: The closure to invoke.
            \tstatic func invokes(
            \t\t_ closure: @Sendable @escaping (Void) async -> Void
            \t) -> Self where Arguments: Sendable {
            \t\t.uncheckedInvokes(closure)
            \t}

            \t/// The implementation as a closure, or `nil` if unimplemented.
            \tvar _closure: Closure? {
            \t\tswitch self {
            \t\tcase .unimplemented:
            \t\t\tnil
            \t\tcase let .uncheckedInvokes(closure):
            \t\t\tclosure
            \t\t}
            \t}
            }

            private let __method = MockVoidParameterizedAsyncMethod<
            \tMethodImplementation<
            \t\t(Void)
            \t>
            >.makeMethod()

            var _method: MockVoidParameterizedAsyncMethod<
            \tMethodImplementation<
            \t\t(Void)
            \t>
            > {
            \tself.__method.method
            }
            """
        )
    }

    @Test
    func asyncAutoClosureWithNonVoidReturnType() {
        assertMockedMethod(
            """
            func method(autoClosure: @escaping @autoclosure () async -> Int) async
            """,
            named: "method",
            generates: """
            func method(autoClosure: @escaping @autoclosure () async -> Int) async {
                let autoClosure = await autoClosure()
                self.__method.recordInput(
                    (
                        autoClosure
                    )
                )
                let _invoke = self.__method.closure()
                await _invoke?(
                    autoClosure
                )
            }

            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedAsyncMethodImplementation {

            \t/// The implementation's closure type.
            \ttypealias Closure = (Int) async -> Void

            \t/// Does nothing when invoked.
            \tcase unimplemented

            \t/// Invokes the provided closure when invoked.
            \t///
            \t/// - Parameter closure: The closure to invoke.
            \tcase uncheckedInvokes(_ closure: Closure)

            \t/// Invokes the provided closure when invoked.
            \t///
            \t/// - Parameter closure: The closure to invoke.
            \tstatic func invokes(
            \t\t_ closure: @Sendable @escaping (Int) async -> Void
            \t) -> Self where Arguments: Sendable {
            \t\t.uncheckedInvokes(closure)
            \t}

            \t/// The implementation as a closure, or `nil` if unimplemented.
            \tvar _closure: Closure? {
            \t\tswitch self {
            \t\tcase .unimplemented:
            \t\t\tnil
            \t\tcase let .uncheckedInvokes(closure):
            \t\t\tclosure
            \t\t}
            \t}
            }

            private let __method = MockVoidParameterizedAsyncMethod<
            \tMethodImplementation<
            \t\t(Int)
            \t>
            >.makeMethod()

            var _method: MockVoidParameterizedAsyncMethod<
            \tMethodImplementation<
            \t\t(Int)
            \t>
            > {
            \tself.__method.method
            }
            """
        )
    }

    @Test
    func throwingAutoClosureWithVoidReturnType() {
        assertMockedMethod(
            """
            func method(autoClosure: @escaping @autoclosure () throws -> Void) throws
            """,
            named: "method",
            generates: """
            func method(autoClosure: @escaping @autoclosure () throws -> Void) throws {
                do {
                    let autoClosure = try autoClosure()
                    self.__method.recordInput(
                        (
                            autoClosure
                        )
                    )
                    let _invoke = self.__method.closure()
                    try _invoke?(
                        autoClosure
                    )
                } catch {
                    self.__method.recordOutput(
                        error
                    )
                    throw error
                }
            }

            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedThrowingMethodImplementation {

            \t/// The implementation's closure type.
            \ttypealias Closure = (Void) throws -> Void

            \t/// Does nothing when invoked.
            \tcase unimplemented

            \t/// Invokes the provided closure when invoked.
            \t///
            \t/// - Parameter closure: The closure to invoke.
            \tcase uncheckedInvokes(_ closure: Closure)

            \t/// Invokes the provided closure when invoked.
            \t///
            \t/// - Parameter closure: The closure to invoke.
            \tstatic func invokes(
            \t\t_ closure: @Sendable @escaping (Void) throws -> Void
            \t) -> Self where Arguments: Sendable {
            \t\t.uncheckedInvokes(closure)
            \t}

            \t/// Throws the provided error when invoked.
            \t///
            \t/// - Parameter error: The error to throw.
            \tstatic func `throws`(
            \t\t_ error: any Error
            \t) -> Self {
            \t\t.uncheckedInvokes { _ in
            \t\t\tthrow error
            \t\t}
            \t}

            \t/// The implementation as a closure, or `nil` if unimplemented.
            \tvar _closure: Closure? {
            \t\tswitch self {
            \t\tcase .unimplemented:
            \t\t\tnil
            \t\tcase let .uncheckedInvokes(closure):
            \t\t\tclosure
            \t\t}
            \t}
            }

            private let __method = MockVoidParameterizedThrowingMethod<
            \tMethodImplementation<
            \t\t(Void)
            \t>
            >.makeMethod()

            var _method: MockVoidParameterizedThrowingMethod<
            \tMethodImplementation<
            \t\t(Void)
            \t>
            > {
            \tself.__method.method
            }
            """
        )
    }

    @Test
    func throwingAutoClosureWithNonVoidReturnType() {
        assertMockedMethod(
            """
            func method(autoClosure: @escaping @autoclosure () throws -> Int) throws
            """,
            named: "method",
            generates: """
            func method(autoClosure: @escaping @autoclosure () throws -> Int) throws {
                do {
                    let autoClosure = try autoClosure()
                    self.__method.recordInput(
                        (
                            autoClosure
                        )
                    )
                    let _invoke = self.__method.closure()
                    try _invoke?(
                        autoClosure
                    )
                } catch {
                    self.__method.recordOutput(
                        error
                    )
                    throw error
                }
            }

            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedThrowingMethodImplementation {

            \t/// The implementation's closure type.
            \ttypealias Closure = (Int) throws -> Void

            \t/// Does nothing when invoked.
            \tcase unimplemented

            \t/// Invokes the provided closure when invoked.
            \t///
            \t/// - Parameter closure: The closure to invoke.
            \tcase uncheckedInvokes(_ closure: Closure)

            \t/// Invokes the provided closure when invoked.
            \t///
            \t/// - Parameter closure: The closure to invoke.
            \tstatic func invokes(
            \t\t_ closure: @Sendable @escaping (Int) throws -> Void
            \t) -> Self where Arguments: Sendable {
            \t\t.uncheckedInvokes(closure)
            \t}

            \t/// Throws the provided error when invoked.
            \t///
            \t/// - Parameter error: The error to throw.
            \tstatic func `throws`(
            \t\t_ error: any Error
            \t) -> Self {
            \t\t.uncheckedInvokes { _ in
            \t\t\tthrow error
            \t\t}
            \t}

            \t/// The implementation as a closure, or `nil` if unimplemented.
            \tvar _closure: Closure? {
            \t\tswitch self {
            \t\tcase .unimplemented:
            \t\t\tnil
            \t\tcase let .uncheckedInvokes(closure):
            \t\t\tclosure
            \t\t}
            \t}
            }

            private let __method = MockVoidParameterizedThrowingMethod<
            \tMethodImplementation<
            \t\t(Int)
            \t>
            >.makeMethod()

            var _method: MockVoidParameterizedThrowingMethod<
            \tMethodImplementation<
            \t\t(Int)
            \t>
            > {
            \tself.__method.method
            }
            """
        )
    }

    @Test
    func asyncThrowingAutoClosureWithVoidReturnType() {
        assertMockedMethod(
            """
            func method(autoClosure: @escaping @autoclosure () async throws -> Void) async throws
            """,
            named: "method",
            generates: """
            func method(autoClosure: @escaping @autoclosure () async throws -> Void) async throws {
                do {
                    let autoClosure = try await autoClosure()
                    self.__method.recordInput(
                        (
                            autoClosure
                        )
                    )
                    let _invoke = self.__method.closure()
                    try await _invoke?(
                        autoClosure
                    )
                } catch {
                    self.__method.recordOutput(
                        error
                    )
                    throw error
                }
            }

            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedAsyncThrowingMethodImplementation {

            \t/// The implementation's closure type.
            \ttypealias Closure = (Void) async throws -> Void

            \t/// Does nothing when invoked.
            \tcase unimplemented

            \t/// Invokes the provided closure when invoked.
            \t///
            \t/// - Parameter closure: The closure to invoke.
            \tcase uncheckedInvokes(_ closure: Closure)

            \t/// Invokes the provided closure when invoked.
            \t///
            \t/// - Parameter closure: The closure to invoke.
            \tstatic func invokes(
            \t\t_ closure: @Sendable @escaping (Void) async throws -> Void
            \t) -> Self where Arguments: Sendable {
            \t\t.uncheckedInvokes(closure)
            \t}

            \t/// Throws the provided error when invoked.
            \t///
            \t/// - Parameter error: The error to throw.
            \tstatic func `throws`(
            \t\t_ error: any Error
            \t) -> Self {
            \t\t.uncheckedInvokes { _ in
            \t\t\tthrow error
            \t\t}
            \t}

            \t/// The implementation as a closure, or `nil` if unimplemented.
            \tvar _closure: Closure? {
            \t\tswitch self {
            \t\tcase .unimplemented:
            \t\t\tnil
            \t\tcase let .uncheckedInvokes(closure):
            \t\t\tclosure
            \t\t}
            \t}
            }

            private let __method = MockVoidParameterizedAsyncThrowingMethod<
            \tMethodImplementation<
            \t\t(Void)
            \t>
            >.makeMethod()

            var _method: MockVoidParameterizedAsyncThrowingMethod<
            \tMethodImplementation<
            \t\t(Void)
            \t>
            > {
            \tself.__method.method
            }
            """
        )
    }

    @Test
    func asyncThrowingAutoClosureWithNonVoidReturnType() {
        assertMockedMethod(
            """
            func method(autoClosure: @escaping @autoclosure () async throws -> Int) async throws
            """,
            named: "method",
            generates: """
            func method(autoClosure: @escaping @autoclosure () async throws -> Int) async throws {
                do {
                    let autoClosure = try await autoClosure()
                    self.__method.recordInput(
                        (
                            autoClosure
                        )
                    )
                    let _invoke = self.__method.closure()
                    try await _invoke?(
                        autoClosure
                    )
                } catch {
                    self.__method.recordOutput(
                        error
                    )
                    throw error
                }
            }

            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedAsyncThrowingMethodImplementation {

            \t/// The implementation's closure type.
            \ttypealias Closure = (Int) async throws -> Void

            \t/// Does nothing when invoked.
            \tcase unimplemented

            \t/// Invokes the provided closure when invoked.
            \t///
            \t/// - Parameter closure: The closure to invoke.
            \tcase uncheckedInvokes(_ closure: Closure)

            \t/// Invokes the provided closure when invoked.
            \t///
            \t/// - Parameter closure: The closure to invoke.
            \tstatic func invokes(
            \t\t_ closure: @Sendable @escaping (Int) async throws -> Void
            \t) -> Self where Arguments: Sendable {
            \t\t.uncheckedInvokes(closure)
            \t}

            \t/// Throws the provided error when invoked.
            \t///
            \t/// - Parameter error: The error to throw.
            \tstatic func `throws`(
            \t\t_ error: any Error
            \t) -> Self {
            \t\t.uncheckedInvokes { _ in
            \t\t\tthrow error
            \t\t}
            \t}

            \t/// The implementation as a closure, or `nil` if unimplemented.
            \tvar _closure: Closure? {
            \t\tswitch self {
            \t\tcase .unimplemented:
            \t\t\tnil
            \t\tcase let .uncheckedInvokes(closure):
            \t\t\tclosure
            \t\t}
            \t}
            }

            private let __method = MockVoidParameterizedAsyncThrowingMethod<
            \tMethodImplementation<
            \t\t(Int)
            \t>
            >.makeMethod()

            var _method: MockVoidParameterizedAsyncThrowingMethod<
            \tMethodImplementation<
            \t\t(Int)
            \t>
            > {
            \tself.__method.method
            }
            """
        )
    }
}
#endif
