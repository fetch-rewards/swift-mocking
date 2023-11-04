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
        /// - Important: This method should only be called from a mock's
        ///   variable conformance declaration. Unless you are writing an
        ///   implementation for a mock, you should never call this method
        ///   directly.
        /// - Parameter newValue: The value to which to set the variable's
        ///   value.
        public mutating func `set`(_ newValue: Value) {
            self.callCount += 1
            self.values.append(newValue)
            self.latestValue = newValue
        }
    }
}
