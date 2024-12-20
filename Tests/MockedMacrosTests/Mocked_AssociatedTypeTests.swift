//
//  Mocked_AssociatedTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import SwiftSyntaxMacrosGenericTestSupport
import Testing
@testable import MockedMacros

struct Mocked_AssociatedTypeTests {

    // MARK: Associated Type Inheritance Tests

    @Test(arguments: testConfigurations)
    func protocolAssociatedTypeInheritanceWithOneInheritedType(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                associatedtype A: Hashable
                associatedtype B: Identifiable
            }
            """,
            generates: """
            \(mock.modifiers)\
            class DependencyMock<A: Hashable, B: Identifiable>: Dependency {
            \(mock.defaultInit)
            }
            """
        )
    }

    @Test(arguments: testConfigurations)
    func protocolAssociatedTypeInheritanceWithMultipleInheritedTypes(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                associatedtype A: Hashable, Identifiable
                associatedtype B: Comparable, Equatable, RawRepresentable
            }
            """,
            generates: """
            \(mock.modifiers)\
            class DependencyMock\
            <A: Hashable & Identifiable, B: Comparable & Equatable & RawRepresentable>\
            : Dependency {
            \(mock.defaultInit)
            }
            """
        )
    }

    // MARK: Associated Type Generic Where Clauses Tests

    @Test(arguments: testConfigurations)
    func protocolAssociatedTypeGenericWhereClauses(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency<A> where A: Hashable {
                associatedtype A: Comparable
                associatedtype B: BidirectionalCollection \
                where B.Element: Equatable, B.Element: Identifiable
                associatedtype C: RandomAccessCollection where C.Element == String
            }
            """,
            generates: """
            \(mock.modifiers)\
            class DependencyMock\
            <A: Comparable, B: BidirectionalCollection, C: RandomAccessCollection>\
            : Dependency where A: Hashable, B.Element: Equatable, \
            B.Element: Identifiable, C.Element == String {
            \(mock.defaultInit)
            }
            """
        )
    }
}
#endif
