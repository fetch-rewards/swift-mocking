//
//  Mocked_InitializerTests.swift
//
//  Copyright © 2025 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct Mocked_InitializerTests {

    // MARK: Default Init Tests

    @Test(arguments: mockedTestConfigurations)
    func defaultInit(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {}
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
            }
            #endif
            """
        )
    }

    // MARK: Init Conformance Tests

    @Test(arguments: mockedTestConfigurations)
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
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                \(mock.memberModifiers)init(parameter: Int) {
                }
                \(mock.memberModifiers)init(parameters: Int...) {
                }
                \(mock.memberModifiers)init(parameter1: Int, parameter2: Int) {
                }
            }
            #endif
            """
        )
    }
}
#endif
