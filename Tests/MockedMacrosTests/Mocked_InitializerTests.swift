//
//  Mocked_InitializerTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/30/24.
//

#if canImport(MockedMacros)
import MockedMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class Mocked_InitializerTests: XCTestCase {

    // MARK: Default Init Tests

    func testDefaultInit() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {}
                """,
                generates: """
                \(mock.modifiers)class DependencyMock: Dependency {
                \(mock.defaultInit)
                }
                """
            )
        }
    }

    // MARK: Init Conformance Tests

    func testInitConformance() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    init(parameter: Int)
                    init(parameter1: Int, parameter2: Int)
                }
                """,
                generates: """
                \(mock.modifiers)class DependencyMock: Dependency {
                \(mock.defaultInit)
                    \(mock.memberModifiers)init(parameter: Int) {
                    }
                    \(mock.memberModifiers)init(parameter1: Int, parameter2: Int) {
                    }
                }
                """
            )
        }
    }
}
#endif
