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
    func readOnlyAsyncSpecifierFactory() {
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
    func readOnlyBothSpecifiersDirect() {
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

    // MARK: AsyncSpecifier Tests

    @Test
    func asyncSpecifierRawValue() {
        #expect(MockedPropertyType.AsyncSpecifier.async.rawValue == "async")
    }

    @Test
    func asyncSpecifierAllCases() {
        #expect(MockedPropertyType.AsyncSpecifier.allCases == [.async])
    }
}
