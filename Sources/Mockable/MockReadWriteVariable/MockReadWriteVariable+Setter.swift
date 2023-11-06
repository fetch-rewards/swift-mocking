//
//  MockReadWriteVariable+Setter.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

extension MockReadWriteVariable {

    /// The invocation records and implementation for a read-write variable's
    /// setter.
    public struct Setter {

        // MARK: Properties

        /// The number of times the setter has been called.
        public private(set) var callCount: Int = .zero

        /// All the values with which the setter has been invoked.
        public private(set) var values: [Value] = []

        /// The latest value with which the setter has been invoked.
        public private(set) var latestValue: Value?

        // MARK: Set

        /// Records the invocation of the variable's setter and sets the
        /// variable's value to the provided value.
        ///
        /// - Parameter newValue: The value to which to set the variable's
        ///   value.
        mutating func `set`(_ newValue: Value) {
            self.callCount += 1
            self.values.append(newValue)
            self.latestValue = newValue
        }
    }
}
