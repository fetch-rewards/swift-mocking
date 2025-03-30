//
//  Mocked_CompilerFlagTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 3/30/25.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct Mocked_CompilerFlagTests {

    // MARK: Compiler Flag Tests

    @Test(arguments: mockedTestConfigurations)
    func compilerFlag(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {}
            """,
            compilerFlag: "DEBUG",
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
}
#endif
