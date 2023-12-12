//
//  Mocked_AccessLevelTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import MockedMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class Mocked_AccessLevelTests: XCTestCase {

    // MARK: Access Level Tests

    func testProtocolAccessLevels() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {}
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                    }
                    """
            )
        }
    }
}
#endif
