# swift-mocking

`swift-mocking` is a collection of Swift macros used to generate mock dependencies.

## Installation

To add `swift-mocking` to a Swift package manifest file:
- Add the `swift-mocking` package to your package's `dependencies`:
  ```swift
  .package(
      url: "https://github.com/fetch-rewards/swift-mocking.git",
      from: "<#latest swift-mocking tag#>"
  )
  ```
- Add the `Mocked` product to your target's `dependencies`:
  ```swift
  .product(name: "Mocked", package: "swift-mocking")
  ```

## Usage

`swift-mocking` contains several Swift macros: `@Mocked`, `@MockedMembers`, `@MockableProperty`, and `@MockableMethod`. 
It also contains two internal, underscored macros: `@_MockedProperty` and `@_MockedMethod` which are not meant to be used directly.

### `@Mocked`
`@Mocked` is an attached, peer macro that generates a mock class from a protocol declaration.
```swift
@Mocked
protocol Dependency {}

// Generates:

@MockedMembers
final class DependencyMock: Dependency {}
```

The generated mock is marked with the access level required to conform to the protocol:
`public` for `public`, implicit `internal` for both implicit and explicit `internal`,
and `fileprivate` for both `fileprivate` and `private`.

`@Mocked` also supports protocols that conform to `Actor`:
```swift
@Mocked protocol Dependency: Actor {}

// Generates:

@MockedMembers
final actor DependencyMock: Dependency {}
```

When `@Mocked` is applied to a protocol that defines associated types, the resulting mock class 
uses those associated types as its generic parameters in order to fulfill the protocol requirements:
```swift
@Mocked
protocol Dependency {
    associatedtype Key: Hashable
    associatedtype Value: Equatable
}

// Generates:

@MockedMembers
final class DependencyMock<Key: Hashable, Value: Equatable>: Dependency {}
```

## Features
`swift-mocking` is Swift 6 compatible, fully concurrency-safe, and generates mocks that can handle:
- [x] Any access level
- [x] Associated types, including primary associated types
- [x] Actor conformance
- [x] Static and instance members
- [x] Read-only properties, including those with getters marked as `async`, `throws`, or `async throws`
- [x] Read-write properties
- [x] Variadic parameters
- [x] Generic methods
- [x] Method overloads
- [ ] Attributed types (`inout`, `consuming`, `sending`, etc.)
- [ ] Typed `throws`

## License

This library is released under the MIT license. See [LICENSE](https://github.com/fetch-rewards/swift-mocking/blob/main/LICENSE) for details.
