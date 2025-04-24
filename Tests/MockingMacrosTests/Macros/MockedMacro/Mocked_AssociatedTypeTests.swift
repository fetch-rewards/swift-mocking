//
//  Mocked_AssociatedTypeTests.swift
//
//  Copyright © 2025 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

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
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock<A: Hashable, B: Identifiable>: Dependency {
            }
            #endif
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
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock<\
            A: Hashable & Identifiable, \
            B: Comparable & Equatable & RawRepresentable\
            >: Dependency {
            }
            #endif
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
            #if SWIFT_MOCKING_ENABLED
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
            #endif
            """
        )
    }
}
#endif
