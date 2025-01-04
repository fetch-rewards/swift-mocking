//
//  Mocked_InheritanceTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_InheritanceTests {

    // MARK: Unconstrained Tests

    @Test(arguments: testConfigurations)
    func unconstrainedProtocol(
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

    // MARK: Actor Constrained Tests

    @Test(arguments: testConfigurations)
    func actorConstrainedProtocol(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: Actor {}
            """,
            generates: """
            \(mock.modifiers)actor DependencyMock: Dependency {
            \(mock.defaultInit)
            }
            """
        )
    }

    // MARK: Class Constrained Tests

    @Test(arguments: testConfigurations)
    func classConstrainedProtocol(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: AnyObject {}
            """,
            generates: """
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
            }
            """
        )
    }

    // MARK: Actor & Class Constrained Tests

    @Test(arguments: testConfigurations)
    func actorAndClassConstrainedProtocol(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: Actor, AnyObject {}
            """,
            generates: """
            \(mock.modifiers)actor DependencyMock: Dependency {
            \(mock.defaultInit)
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func classAndActorConstrainedProtocol(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency: AnyObject, Actor {}
            """,
            generates: """
            \(mock.modifiers)actor DependencyMock: Dependency {
            \(mock.defaultInit)
            }
            """
        )
    }
}
#endif
