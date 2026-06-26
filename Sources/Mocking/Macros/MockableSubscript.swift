//
//  MockableSubscript.swift
//
//  Copyright © 2026 Fetch.
//

/// A macro that marks a subscript as being mockable.
///
/// This macro does not itself produce an expansion and is intended to be used
/// in conjunction with the `@MockedMembers` macro:
/// ```swift
/// @MockedMembers
/// final class DataStoreMock: DataStore {
///     @MockableSubscript(.readWrite)
///     subscript(key: String) -> String?
/// }
/// ```
///
/// - Parameter subscriptType: The type of subscript being mocked.
@attached(accessor)
public macro MockableSubscript(_ subscriptType: MockedSubscriptType) = #externalMacro(
    module: "MockingMacros",
    type: "MockableSubscriptMacro"
)
