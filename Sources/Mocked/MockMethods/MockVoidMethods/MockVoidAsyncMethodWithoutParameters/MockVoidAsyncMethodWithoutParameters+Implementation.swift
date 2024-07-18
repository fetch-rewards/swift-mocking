//
//  MockVoidAsyncMethodWithoutParameters+Implementation.swift
//  Mocked
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import XCTestDynamicOverlay

extension MockVoidAsyncMethodWithoutParameters {

    /// An implementation for a mock's void, async method without parameters.
    public enum Implementation {

        // MARK: Cases

        /// Does nothing when invoked.
        case unimplemented

        /// Invokes a closure when invoked.
        case invokes(() async -> Void)

        // MARK: Call As Function

        /// Invokes the implementation, doing nothing if the implementation is
        /// ``unimplemented`` or invoking a closure if the implementation is
        /// ``invokes(_:)``.
        func callAsFunction() async {
            switch self {
            case .unimplemented:
                return
            case let .invokes(closure):
                await closure()
            }
        }
    }
}
