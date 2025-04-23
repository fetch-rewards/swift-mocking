//
//  Mocked_InheritanceTests.swift
//  MockingMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct Mocked_InheritanceTests {

    // MARK: Unconstrained Tests

    @Test(arguments: mockedTestConfigurations)
    func unconstrainedProtocol(
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

    // MARK: Actor Constrained Tests

    @Test(arguments: mockedTestConfigurations)
    func actorConstrainedProtocol(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: Actor {}
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)actor DependencyMock: Dependency {
            }
            #endif
            """
        )
    }

    // MARK: Class Constrained Tests

    @Test(arguments: mockedTestConfigurations)
    func classConstrainedProtocol(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: AnyObject {}
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

    // MARK: Actor & Class Constrained Tests

    @Test(arguments: mockedTestConfigurations)
    func actorAndClassConstrainedProtocol(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: Actor, AnyObject {}
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)actor DependencyMock: Dependency {
            }
            #endif
            """
        )
    }

    @Test(arguments: mockedTestConfigurations)
    func classAndActorConstrainedProtocol(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: AnyObject, Actor {}
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)actor DependencyMock: Dependency {
            }
            #endif
            """
        )
    }
}
#endif
