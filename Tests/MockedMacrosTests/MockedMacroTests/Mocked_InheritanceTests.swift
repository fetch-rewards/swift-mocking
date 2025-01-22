//
//  Mocked_InheritanceTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct Mocked_InheritanceTests {

    // MARK: Unconstrained Tests

    @Test(arguments: mockedTestConfigurations)
    func unconstrainedProtocol(
        interface: MockInterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {}
            """,
            generates: """
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
            }
            """
        )
    }

    // MARK: Actor Constrained Tests

    @Test(arguments: mockedTestConfigurations)
    func actorConstrainedProtocol(
        interface: MockInterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: Actor {}
            """,
            generates: """
            @MockedMembers
            \(mock.modifiers)actor DependencyMock: Dependency {
            \(mock.defaultInit)
            }
            """
        )
    }

    // MARK: Class Constrained Tests

    @Test(arguments: mockedTestConfigurations)
    func classConstrainedProtocol(
        interface: MockInterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: AnyObject {}
            """,
            generates: """
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
            }
            """
        )
    }

    // MARK: Actor & Class Constrained Tests

    @Test(arguments: mockedTestConfigurations)
    func actorAndClassConstrainedProtocol(
        interface: MockInterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: Actor, AnyObject {}
            """,
            generates: """
            @MockedMembers
            \(mock.modifiers)actor DependencyMock: Dependency {
            \(mock.defaultInit)
            }
            """
        )
    }

    @Test(arguments: mockedTestConfigurations)
    func classAndActorConstrainedProtocol(
        interface: MockInterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: AnyObject, Actor {}
            """,
            generates: """
            @MockedMembers
            \(mock.modifiers)actor DependencyMock: Dependency {
            \(mock.defaultInit)
            }
            """
        )
    }
}
#endif
