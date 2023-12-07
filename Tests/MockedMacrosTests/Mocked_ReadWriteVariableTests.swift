//
//  Mocked_ReadWriteVariableTests.swift
//  MockedMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockedMacros)
import MockedMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class Mocked_ReadWriteVariableTests: XCTestCase {

    // MARK: Read-Write Variable Tests

    func testReadWriteVariable() {
        testMocked { interface, mock in
            assertMocked(
                """
                \(interface.accessLevel) protocol Dependency {
                    var variable: String { get set }
                }
                """,
                generates: """
                    \(mock.modifiers)class DependencyMock: Dependency {
                    \(mock.defaultInit)
                        private let __variable = MockReadWriteVariable<String> .makeVariable(
                            exposedVariableDescription: MockImplementationDescription(
                                type: DependencyMock.self,
                                member: "_variable"
                            )
                        )
                        \(mock.memberModifiers)var _variable: MockReadWriteVariable<String> {
                            self.__variable.variable
                        }
                        \(mock.memberModifiers)var variable: String {
                            get {
                                self.__variable.get()
                            }
                            set {
                                self.__variable.set(newValue)
                            }
                        }
                    }
                    """
            )
        }
    }
}
#endif
