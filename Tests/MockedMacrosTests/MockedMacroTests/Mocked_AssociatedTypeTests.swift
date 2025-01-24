//
//  Mocked_AssociatedTypeTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct Mocked_AssociatedTypeTests {

    // MARK: Associated Type Inheritance Tests

    @Test(arguments: mockedTestConfigurations)
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
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock<A: Hashable, B: Identifiable>: Dependency {
            }
            """
        )
    }

    @Test(arguments: mockedTestConfigurations)
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
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock<\
            A: Hashable & Identifiable, \
            B: Comparable & Equatable & RawRepresentable\
            >: Dependency {
            }
            """
        )
    }

    // MARK: Associated Type Generic Where Clauses Tests

    @Test(arguments: mockedTestConfigurations)
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
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock<\
            A: Comparable, \
            B: BidirectionalCollection, \
            C: RandomAccessCollection\
            >: Dependency where \
            A: Hashable, \
            B.Element: Equatable, B.Element: Identifiable, \
            C.Element == String {
            }
            """
        )
    }
}
#endif
