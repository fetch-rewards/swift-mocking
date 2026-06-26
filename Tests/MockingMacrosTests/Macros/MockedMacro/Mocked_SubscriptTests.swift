//
//  Mocked_SubscriptTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct Mocked_SubscriptTests {

    // MARK: Read-Only Subscript Tests

    @Test(arguments: mockedTestConfigurations)
    func readOnlySubscript(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                subscript(key: String) -> String? { get }
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                @MockableSubscript(.readOnly)
                \(mock.memberModifiers)subscript(key: String) -> String?
            }
            #endif
            """
        )
    }

    // MARK: Read-Write Subscript Tests

    @Test(arguments: mockedTestConfigurations)
    func readWriteSubscript(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                subscript(key: String) -> String? { get set }
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                @MockableSubscript(.readWrite)
                \(mock.memberModifiers)subscript(key: String) -> String?
            }
            #endif
            """
        )
    }

    // MARK: Multi-Parameter Subscript Tests

    @Test(arguments: mockedTestConfigurations)
    func multiParameterSubscript(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {
                subscript(key: String, default defaultValue: String) -> String { get set }
            }
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
                @MockableSubscript(.readWrite)
                \(mock
                .memberModifiers)subscript(key: String, default defaultValue: String) -> String
            }
            #endif
            """
        )
    }
}
#endif
