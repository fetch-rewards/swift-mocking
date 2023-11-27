//
//  Mockable_AssociatedTypeTests.swift
//  MockableMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockableMacros)
import MockableMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class Mockable_AssociatedTypeTests: XCTestCase {

    // MARK: Associated Type Inheritance Tests

    func testProtocolAssociatedTypeInheritanceWithOneInheritedType() {
        testMockable { interface, mock in
            assertMockable("""
                    \(interface.accessLevel) protocol Dependency {
                        associatedtype A: Hashable
                        associatedtype B: Identifiable
                    }
                    """,
                generates: """
                    \(mock.modifiers)class DependencyMock<A: Hashable, B: Identifiable>: Dependency {
                    \(mock.defaultInit)
                    }
                    """
            )
        }
    }

    func testProtocolAssociatedTypeInheritanceWithMultipleInheritedTypes() {
        testMockable { interface, mock in
            assertMockable("""
                    \(interface.accessLevel) protocol Dependency {
                        associatedtype A: Hashable, Identifiable
                        associatedtype B: Comparable, Equatable, RawRepresentable
                    }
                    """,
                generates: """
                    \(mock.modifiers)class DependencyMock<A: Hashable & Identifiable, B: Comparable & Equatable & RawRepresentable>: Dependency {
                    \(mock.defaultInit)
                    }
                    """
            )
        }
    }

    // MARK: Associated Type Generic Where Clauses Tests

    func testProtocolAssociatedTypeGenericWhereClauses() {
        testMockable { interface, mock in
            assertMockable("""
                    \(interface.accessLevel) protocol Dependency<A> where A: Hashable {
                        associatedtype A: Comparable
                        associatedtype B: BidirectionalCollection where B.Element: Equatable, B.Element: Identifiable
                        associatedtype C: RandomAccessCollection where C.Element == String
                    }
                    """,
                generates: """
                    \(mock.modifiers)class DependencyMock<A: Comparable, B: BidirectionalCollection, C: RandomAccessCollection>: Dependency where A: Hashable, B.Element: Equatable, B.Element: Identifiable, C.Element == String {
                    \(mock.defaultInit)
                    }
                    """
            )
        }
    }
}
#endif
