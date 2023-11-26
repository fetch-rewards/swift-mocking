//
//  MockImplementation.swift
//  Mockable
//
//  Created by Cole Campbell on 11/11/23.
//

import Foundation
import XCTestDynamicOverlay

public enum MockImplementation<Value> {
    case unimplemented
    case returns(Value)

    func callAsFunction(description: MockImplementationDescription) -> Value {
        switch self {
        case .unimplemented:
            XCTestDynamicOverlay.unimplemented("\(description)")
        case .returns(let value):
            value
        }
    }
}
