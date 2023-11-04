import Foundation

/// The invocation records and implementation for a mock's read-only variable.
public struct MockReadOnlyVariable<Value> {
    
    // MARK: Properties
    
    /// The variable's getter.
    public var getter = Getter()
    
    // MARK: Initializers
    
    /// Creates a read-only variable.
    public init() {}
}
