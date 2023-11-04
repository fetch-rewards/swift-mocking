//
//  MockReadWriteVariable.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's read-write variable.
public struct MockReadWriteVariable<Value> {

    // MARK: Properties

    /// The variable's getter.
    public var getter = Getter()

    /// The variable's setter.
    public var setter = Setter()

    // MARK: Initializers

    /// Creates a read-write variable.
    public init() {}
}
