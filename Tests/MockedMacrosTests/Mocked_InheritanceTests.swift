//
//  Mocked_InheritanceTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import MockedMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class Mocked_InheritanceTests: XCTestCase {

    // MARK: Unconstrained Tests

    func testUnconstrainedProtocol() {
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

    // MARK: Actor Constrained Tests

    func testActorConstrainedProtocol() {
        testMocked { interface, mock in
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
    }

    // MARK: Class Constrained Tests

    func testClassConstrainedProtocol() {
        testMocked { interface, mock in
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
    }

    // MARK: Actor & Class Constrained Tests

    func testActorAndClassConstrainedProtocol() {
        testMocked { interface, mock in
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
    }

    func testClassAndActorConstrainedProtocol() {
        testMocked { interface, mock in
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
}
#endif
