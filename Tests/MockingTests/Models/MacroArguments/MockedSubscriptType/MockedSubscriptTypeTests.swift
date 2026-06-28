//
//  MockedSubscriptTypeTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import Mocking

struct MockedSubscriptTypeTests {

    // MARK: Read-Only Tests

    @Test
    func readOnly_staticProperty() {
        guard case .readOnly(nil, nil) = MockedSubscriptType.readOnly else {
            Issue.record("Expected .readOnly(nil, nil)")
            return
        }
    }

    @Test
    func readOnly_noSpecifiers() {
        guard case .readOnly(nil, nil) = MockedSubscriptType.readOnly() else {
            Issue.record("Expected .readOnly(nil, nil)")
            return
        }
    }

    @Test
    func readOnly_asyncSpecifier() {
        guard case .readOnly(.async, nil) = MockedSubscriptType.readOnly(.async, nil) else {
            Issue.record("Expected .readOnly(.async, nil)")
            return
        }
    }

    @Test
    func readOnly_throwsSpecifier_factory() {
        guard case .readOnly(nil, .throws) = MockedSubscriptType.readOnly(.throws) else {
            Issue.record("Expected .readOnly(nil, .throws)")
            return
        }
    }

    @Test
    func readOnly_throwsSpecifier_direct() {
        guard case .readOnly(nil, .throws) = MockedSubscriptType.readOnly(nil, .throws) else {
            Issue.record("Expected .readOnly(nil, .throws)")
            return
        }
    }

    @Test
    func readOnly_asyncAndThrows() {
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

    // MARK: AsyncSpecifier Tests

    @Test
    func asyncSpecifier_rawValue() {
        #expect(MockedSubscriptType.AsyncSpecifier.async.rawValue == "async")
    }

    @Test
    func asyncSpecifier_allCases() {
        #expect(MockedSubscriptType.AsyncSpecifier.allCases == [.async])
    }
}
