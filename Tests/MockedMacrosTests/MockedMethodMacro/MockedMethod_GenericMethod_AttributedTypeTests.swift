//
//  MockedMethod_GenericMethod_AttributedTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 1/10/25.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct MockedMethod_GenericMethod_AttributedTypeTests {

    // MARK: Attributed Type Tests

    @Test
    func genericMethodWithAttributedTypeAndUnconstrainedGenericParameter() {
        assertMockedMethod(
            """
            func method<Value>(parameter: inout Value)
            """,
            generates: """
            func method<Value>(parameter: inout Value) {
                self.__method.invoke((parameter))
            }
            
            private let __method = MockVoidMethodWithParameters<
            \t(Any)
            >.makeMethod()
            
            var _method: MockVoidMethodWithParameters<
            \t(Any)
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
            generates: """
            func method<Value: Equatable>(parameter: inout Value) \
            where Value: Sendable, Value: Comparable & Hashable {
                self.__method.invoke((parameter))
            }
            
            private let __method = MockVoidMethodWithParameters<
            \t(any (Equatable & Sendable & Comparable & Hashable))
            >.makeMethod()
            
            var _method: MockVoidMethodWithParameters<
            \t(any (Equatable & Sendable & Comparable & Hashable))
            > {
                self.__method.method
            }
            """
        )
    }
}
#endif
