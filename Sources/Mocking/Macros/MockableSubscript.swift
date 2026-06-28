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

/// A macro that marks a subscript as being mockable with an explicit mock
/// subscript name.
///
/// This macro does not itself produce an expansion and is intended to be used
/// in conjunction with the `@MockedMembers` macro. The ``MockedMembers()``
/// macro is capable of resolving most naming conflicts caused by subscript
/// overloads, but in cases where it is unable to successfully resolve those
/// conflicts, this macro may be used to provide a unique `mockSubscriptName`
/// for a subscript.
///
/// - Parameters:
///   - subscriptType: The type of subscript being mocked.
///   - mockSubscriptName: The name to use for the mock subscript.
@attached(accessor)
public macro MockableSubscript(
    _ subscriptType: MockedSubscriptType,
    mockSubscriptName: String
) = #externalMacro(
    module: "MockingMacros",
    type: "MockableSubscriptMacro"
)
