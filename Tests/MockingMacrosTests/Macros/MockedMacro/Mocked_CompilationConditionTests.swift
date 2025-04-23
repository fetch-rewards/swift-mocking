//
//  Mocked_CompilationConditionTests.swift
//  MockingMacrosTests
//
//  Created by Gray Campbell on 3/30/25.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct Mocked_CompilationConditionTests {

    // MARK: Compilation Condition Tests

    @Test(arguments: mockedTestConfigurations)
    func defaultCompilationCondition(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {}
            """,
            compilationCondition: nil,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock: Dependency {
            }
            #endif
            """
        )
    }

    @Test(arguments: mockedTestConfigurations)
    func noneCompilationCondition(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {}
            """,
            compilationCondition: ".none",
            generates: """
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock: Dependency {
            }
            """
        )
    }

    @Test(arguments: mockedTestConfigurations)
    func debugCompilationCondition(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {}
            """,
            compilationCondition: ".debug",
            generates: """
            #if DEBUG
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock: Dependency {
            }
            #endif
            """
        )
    }

    @Test(arguments: mockedTestConfigurations)
    func swiftMockingEnabledCompilationCondition(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {}
            """,
            compilationCondition: ".swiftMockingEnabled",
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock: Dependency {
            }
            #endif
            """
        )
    }

    @Test(arguments: mockedTestConfigurations)
    func customCompilationCondition(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {}
            """,
            compilationCondition: #".custom("!RELEASE")"#,
            generates: """
            #if !RELEASE
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock: Dependency {
            }
            #endif
            """
        )
    }

    @Test(arguments: mockedTestConfigurations)
    func stringLiteralCompilationCondition(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {}
            """,
            compilationCondition: #""!RELEASE""#,
            generates: """
            #if !RELEASE
            @MockedMembers
            \(mock.modifiers)\
            class DependencyMock: Dependency {
            }
            #endif
            """
        )
    }
}
#endif
