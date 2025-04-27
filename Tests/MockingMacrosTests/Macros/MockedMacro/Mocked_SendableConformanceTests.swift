//
//  Mocked_SendableConformanceTests.swift
//
//  Copyright © 2025 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct Mocked_SendableConformanceTests {
    
    @Test(
        "Default conformance doesn't modify inheritance clause.",
        arguments: mockedTestConfigurations
    )
    func defaultSendableConformance(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: Sendable {}
            """,
            sendableConformance: nil,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock: Dependency {
            }
            #endif
            """
        )
    }
    
    @Test(
        "Checked conformance doesn't modify inheritance clause.",
        arguments: mockedTestConfigurations
    )
    func checkedSendableConformance(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: Sendable {}
            """,
            sendableConformance: .checked,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock: Dependency {
            }
            #endif
            """
        )
    }
    
    @Test(
        "Unchecked conformance adds @unchecked Sendable to inheritance clause.",
        arguments: mockedTestConfigurations
    )
    func uncheckedSendableConformance(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: Sendable {}
            """,
            sendableConformance: .unchecked,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock: @unchecked Sendable, Dependency {
            }
            #endif
            """
        )
    }
}

#endif
