//
//  Mockable_ReadWriteVariableTests.swift
//  MockableMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockableMacros)
import MockableMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class Mockable_ReadWriteVariableTests: XCTestCase {

    // MARK: Read-Write Variable Tests

    func testReadWriteVariable() {
        testMockable { interface, mock in
            assertMockable(
                """
                \(interface.accessLevel) protocol Dependency {
                    var variable: String { get set }
                }
                """,
                generates: """
                \(mock.modifiers)class DependencyMock: Dependency {
                \(mock.defaultInit)
                    \(mock.memberModifiers)var _variable = MockReadWriteVariable<String>()
                    \(mock.memberModifiers)var variable: String {
                        get {
                            self._variable.getter.get()
                        }
                        set {
                            self._variable.setter.set(newValue)
                        }
                    }
                }
                """
            )
        }
    }
}
#endif
