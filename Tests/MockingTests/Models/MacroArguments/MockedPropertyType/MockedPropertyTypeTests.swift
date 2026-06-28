//
//  MockedPropertyTypeTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import Mocking

struct MockedPropertyTypeTests {

    // MARK: Typealiases

    typealias SUT = MockedPropertyType

    // MARK: Read-Only Tests

    @Test
    func readOnlyStaticProperty() {
        guard case .readOnly(nil, nil) = MockedPropertyType.readOnly else {
            Issue.record("Expected .readOnly(nil, nil)")
            return
        }
    }

    @Test
    func readOnlyAsyncSpecifier() {
        guard case .readOnly(.async, nil) = MockedPropertyType.readOnly(.async) else {
            Issue.record("Expected .readOnly(.async, nil)")
            return
        }
    }

    @Test
    func readOnlyThrowsSpecifierFactory() {
        guard case .readOnly(nil, .throws) = MockedPropertyType.readOnly(.throws) else {
            Issue.record("Expected .readOnly(nil, .throws)")
            return
        }
    }

    @Test
    func readOnlyThrowsSpecifierDirect() {
        guard case .readOnly(nil, .throws) = MockedPropertyType.readOnly(nil, .throws) else {
            Issue.record("Expected .readOnly(nil, .throws)")
            return
        }
    }

    @Test
    func readOnlyAsyncAndThrows() {
        guard case .readOnly(.async, .throws) = MockedPropertyType.readOnly(.async, .throws) else {
            Issue.record("Expected .readOnly(.async, .throws)")
            return
        }
    }

    // MARK: Read-Write Tests

    @Test
    func readWrite() {
        guard case .readWrite = MockedPropertyType.readWrite else {
            Issue.record("Expected .readWrite")
            return
        }
    }
}
