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
            generates: """
            func method(strings: String..., integers: Int...) {
                self.__method.invoke((strings, integers))
            }
            
            private let __method = MockVoidMethodWithParameters<
            \t(strings: [String], integers: [Int])
            >.makeMethod()
            
            var _method: MockVoidMethodWithParameters<
            \t(strings: [String], integers: [Int])
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
