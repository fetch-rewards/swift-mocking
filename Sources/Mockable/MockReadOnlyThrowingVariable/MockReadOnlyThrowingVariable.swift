import Foundation

/// The invocation records and implementation for a mock's read-only, throwing
/// variable.
public struct MockReadOnlyThrowingVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter = Getter()

    // MARK: Initializers

    /// Creates a read-only, throwing variable.
    public init() {}
}
