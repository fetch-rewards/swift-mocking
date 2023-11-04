import Foundation
import XCTestDynamicOverlay

extension MockReadOnlyVariable {
    
    /// The invocation records and implementation for a read-only variable's
    /// getter.
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
        /// - Important: This method should only be called from a mock's
        ///   variable conformance declaration. Unless you are writing an
        ///   implementation for a mock, you should never call this method
        ///   directly.
        /// - Returns: The variable's value.
        public mutating func `get`() -> Value {
            guard let value = self.value else {
                return unimplemented("\(Self.self).value")
            }

            self.callCount += 1

            return value
        }
    }
}
