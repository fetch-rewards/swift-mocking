//
//  MockedSubscriptTypeTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import Mocking

struct MockedSubscriptTypeTests {

    // MARK: Typealiases

    typealias SUT = MockedSubscriptType

    // MARK: Read-Only Tests

    @Test
    func readOnlyStaticProperty() {
        guard case .readOnly(nil, nil) = MockedSubscriptType.readOnly else {
            Issue.record("Expected .readOnly(nil, nil)")
            return
        }
    }

    @Test
    func readOnlyAsyncSpecifier() {
        guard case .readOnly(.async, nil) = MockedSubscriptType.readOnly(.async) else {
            Issue.record("Expected .readOnly(.async, nil)")
            return
        }
    }

    @Test
    func readOnlyThrowsSpecifierFactory() {
        guard case .readOnly(nil, .throws) = MockedSubscriptType.readOnly(.throws) else {
            Issue.record("Expected .readOnly(nil, .throws)")
            return
        }
    }

    @Test
    func readOnlyThrowsSpecifierDirect() {
        guard case .readOnly(nil, .throws) = MockedSubscriptType.readOnly(nil, .throws) else {
            Issue.record("Expected .readOnly(nil, .throws)")
            return
        }
    }

    @Test
    func readOnlyAsyncAndThrows() {
        guard case .readOnly(.async, .throws) = MockedSubscriptType.readOnly(.async, .throws) else {
            Issue.record("Expected .readOnly(.async, .throws)")
            return
        }
    }

    // MARK: Read-Write Tests

    @Test
    func readWrite() {
        guard case .readWrite = MockedSubscriptType.readWrite else {
            Issue.record("Expected .readWrite")
            return
        }
    }

}
