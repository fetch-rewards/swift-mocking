//
//  Mockable_AccessLevelTests.swift
//  MockableMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockableMacros)
import MockableMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class Mockable_AccessLevelTests: XCTestCase {
    
    // MARK: Access Level Tests
    
    func testProtocolAccessLevels() {
        testMockable { interface, mock in
            assertMockable(
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
