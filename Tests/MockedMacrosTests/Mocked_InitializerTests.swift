//
//  Mocked_InitializerTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/30/24.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_InitializerTests {

    // MARK: Default Init Tests

    @Test(arguments: testConfigurations)
    func defaultInit(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
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

    // MARK: Init Conformance Tests

    @Test(arguments: testConfigurations)
    func initConformance(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                init(parameter: Int)
                init(parameters: Int...)
                init(parameter1: Int, parameter2: Int)
            }
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
                \(mock.memberModifiers)init(parameter: Int) {
                }
                \(mock.memberModifiers)init(parameters: Int...) {
                }
                \(mock.memberModifiers)init(parameter1: Int, parameter2: Int) {
                }
            }
            """
        )
    }
}
#endif
