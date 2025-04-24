//
//  Result+AsyncCatching.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation

extension Result where Failure == any Error {

    // MARK: Initializers

    /// Creates a result by evaluating an async throwing closure, capturing the
    /// returned value as a success or any thrown error as a failure.
    ///
    /// - Parameter body: An async throwing closure to evaluate.
    init(catching body: () async throws -> Success) async {
        do {
            self = .success(try await body())
        } catch {
            self = .failure(error)
        }
    }
}
