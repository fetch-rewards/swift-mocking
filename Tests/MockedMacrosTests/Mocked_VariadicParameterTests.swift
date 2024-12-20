//
//  Mocked_VariadicParameterTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 12/20/24.
//

#if canImport(MockedMacros)
import MockedMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class Mocked_VariadicParameterTests: XCTestCase {

    // MARK: Variadic Parameter Tests

    func testVariadicParameters() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    func method(strings: String..., integers: Int...)
                }
                """,
                generates: """
                \(mock.modifiers)class DependencyMock: Dependency {
                \(mock.defaultInit)
                    private let __method = MockVoidMethodWithParameters<(strings: [String], \
                integers: [Int])>.makeMethod()
                    \(mock.memberModifiers)var _method: MockVoidMethodWithParameters<\
                (strings: [String], integers: [Int])> {
                        self.__method.method
                    }
                    \(mock.memberModifiers)func method(strings: String..., integers: Int...) {
                        self.__method.invoke((strings, integers))
                    }
                }
                """
            )
        }
    }
}
#endif
