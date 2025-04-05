//
//  MockingPlugin.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MockingPlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [
        MockedMacro.self,
        MockedMembersMacro.self,
        MockedMethodMacro.self,
        MockablePropertyMacro.self,
        MockedPropertyMacro.self,
    ]
}
