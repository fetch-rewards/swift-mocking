//
//  MockedMethod_VariadicParameterTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 12/20/24.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct MockedMethod_VariadicParameterTests {

    // MARK: Variadic Parameter Tests

    @Test
    func variadicParameters() {
        assertMockedMethod(
            """
            func method(strings: String..., integers: Int...)
            """,
            named: "method",
            generates: """
            func method(strings: String..., integers: Int...) {
                self.__method.recordInput(
                    (
                        strings,
                        integers
                    )
                )
                let _invoke = self.__method.closure()
                _invoke?(
                    strings,
                    integers
                )
            }
            
            /// An implementation for `DependencyMock._method`.
            enum MethodImplementation<
            \tArguments
            >: @unchecked Sendable, MockVoidParameterizedMethodImplementation {

                /// The implementation's closure type.
                typealias Closure = ([String], [Int]) -> Void

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
                \t_ closure: @Sendable @escaping ([String], [Int]) -> Void
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
            \t\t(strings: [String], integers: [Int])
            \t>
            >.makeMethod()
            
            var _method: MockVoidParameterizedMethod<
            \tMethodImplementation<
            \t\t(strings: [String], integers: [Int])
            \t>
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
