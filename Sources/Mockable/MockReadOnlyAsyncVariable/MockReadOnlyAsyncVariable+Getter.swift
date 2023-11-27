//
//  MockReadOnlyAsyncVariable+Getter.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import XCTestDynamicOverlay

extension MockReadOnlyAsyncVariable {

    /// The invocation records and implementation for a read-only, async
    /// variable's getter.
    public struct Getter {

        // MARK: Properties

        /// The getter's value.
        public var value: Value?

        /// The number of times the getter has been called.
        public private(set) var callCount: Int = .zero

        // MARK: Get

        /// Records the invocation of the variable's getter and returns the
        /// variable's value.
        ///
        /// - Returns: The variable's value.
        mutating func `get`() async -> Value {
            guard let value = self.value else {
                return unimplemented("\(Self.self).value")
            }

            self.callCount += 1

            return value
        }
    }
}
