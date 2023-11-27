//
//  Mockable_InheritanceTests.swift
//  MockableMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockableMacros)
import MockableMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class Mockable_InheritanceTests: XCTestCase {

    // MARK: Unconstrained Tests

    func testUnconstrainedProtocol() {
        testMockable { interface, mock in
            assertMockable("""
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
        testMockable { interface, mock in
            assertMockable("""
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
        testMockable { interface, mock in
            assertMockable("""
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
        testMockable { interface, mock in
            assertMockable("""
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
        testMockable { interface, mock in
            assertMockable("""
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
