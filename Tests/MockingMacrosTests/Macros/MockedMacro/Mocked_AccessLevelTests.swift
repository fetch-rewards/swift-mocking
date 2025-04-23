//
//  Mocked_AccessLevelTests.swift
//  MockingMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct Mocked_AccessLevelTests {

    // MARK: Access Level Tests

    @Test(arguments: mockedTestConfigurations)
    func protocolAccessLevels(
        interface: InterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {}
            """,
            generates: """
            #if SWIFT_MOCKING_ENABLED
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
            }
            #endif
            """
        )
    }
}
#endif
