//
//  Mocked_AccessLevelTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import Testing
@testable import MockedMacros

struct Mocked_AccessLevelTests {

    // MARK: Access Level Tests

    @Test(arguments: mockedTestConfigurations)
    func protocolAccessLevels(
        interface: MockInterfaceConfiguration,
        mock: MockConfiguration
    ) {
        assertMocked(
            """
            \(interface.accessLevel) protocol Dependency {}
            """,
            generates: """
            @MockedMembers
            \(mock.modifiers)class DependencyMock: Dependency {
            \(mock.defaultInit)
            }
            """
        )
    }
}
#endif
