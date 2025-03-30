//
//  Mocked_CompilationConditionTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 3/30/25.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct Mocked_CompilationConditionTests {

    // MARK: Compilation Condition Tests

    @Test(arguments: mockedTestConfigurations)
    func debugCompilationCondition(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {}
            """,
            compilationCondition: "DEBUG",
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
    func notReleaseCompilationCondition(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {}
            """,
            compilationCondition: "!RELEASE",
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
