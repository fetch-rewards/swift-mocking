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
                self.__method.invoke((parameter))
            }
            
            private let __method = MockVoidMethodWithParameters<
            \t(any Equatable)
            >.makeMethod()
            
            var _method: MockVoidMethodWithParameters<
            \t(any Equatable)
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
                self.__method.invoke((parameter))
            }
            
            private let __method = MockVoidMethodWithParameters<
            \t(any (Equatable & Sendable & Comparable))
            >.makeMethod()
            
            var _method: MockVoidMethodWithParameters<
            \t(any (Equatable & Sendable & Comparable))
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
