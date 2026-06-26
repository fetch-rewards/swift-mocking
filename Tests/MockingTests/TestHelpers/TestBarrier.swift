//
//  TestBarrier.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation

/// A synchronization primitive that ensures a specific number of async tasks
/// all start executing simultaneously, useful for testing race conditions.
///
/// The barrier works by dispatching each task's wait to a GCD thread, which
/// blocks at the OS level on an `NSCondition`. Once all expected tasks have
/// arrived, the last thread broadcasts to release all blocked threads
/// simultaneously. Each GCD thread then resumes its async continuation,
/// submitting all tasks to the Swift cooperative executor at the same time.
///
/// This guarantees true concurrent execution because:
/// - GCD threads block at the OS level, not the cooperative scheduler level
/// - `NSCondition.broadcast()` releases all threads simultaneously
/// - Continuations are resumed asynchronously from separate OS threads, so the
///   cooperative executor receives all tasks as runnable at the same moment
///
/// ```swift
/// let taskCount = 100
/// let barrier = TestBarrier(totalTasks: taskCount)
///
/// await withTaskGroup(of: Void.self) { group in
///     for _ in 0..<taskCount {
///         group.addTask {
///             await barrier.wait() // All tasks wait here
///             someOperation()      // All execute simultaneously
///         }
///     }
/// }
/// ```
final class TestBarrier: @unchecked Sendable {

    // MARK: Properties

    /// The default number of tasks used when no task count is specified.
    static let defaultTaskCount = 100

    /// The condition variable used to block and release GCD threads.
    private let condition = NSCondition()

    /// The number of tasks that have arrived at the barrier so far.
    private var arrivedCount: Int = .zero

    /// The total number of tasks that must arrive before any are released.
    private let totalTasks: Int

    // MARK: Initializers

    /// Creates a barrier that will release all tasks once the specified number
    /// of tasks have called `wait()`.
    ///
    /// - Parameter totalTasks: The number of tasks that must call `wait()`
    ///   before any are released.
    init(totalTasks: Int) {
        self.totalTasks = totalTasks
    }

    // MARK: Wait

    /// Suspends the current task until all expected tasks have called this
    /// method.
    ///
    /// This method dispatches to a GCD global queue thread, which blocks at the
    /// OS level on an `NSCondition`. When the last expected task arrives, all
    /// blocked GCD threads are released simultaneously via `broadcast()`. Each
    /// thread then resumes its async continuation, returning all tasks to the
    /// cooperative executor at the same time.
    ///
    /// - Warning: This method should only be called by the exact number of
    ///   tasks specified in `totalTasks`. Calling it more times will have no
    ///   effect, but calling it fewer times will cause tasks to wait
    ///   indefinitely.
    func wait() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                self.condition.lock()
                self.arrivedCount += 1

                if self.arrivedCount == self.totalTasks {
                    // Last task to arrive: release everyone, including self.
                    self.condition.broadcast()
                }

                // Loop guards against spurious wakeups.
                while self.arrivedCount < self.totalTasks {
                    self.condition.wait()
                }

                self.condition.unlock()
                continuation.resume()
            }
        }
    }

    // MARK: Execute Concurrently

    /// Executes a block concurrently across multiple tasks, all starting
    /// simultaneously.
    ///
    /// This is a convenience method that creates a barrier, spawns the
    /// specified number of tasks in a task group, and ensures they all execute
    /// the provided block at exactly the same time. This is particularly useful
    /// for testing race conditions in concurrent code.
    ///
    /// ```swift
    /// // Test race condition with default 100 tasks
    /// await TestBarrier.executeConcurrently {
    ///     unsafeCounter += 1
    /// }
    ///
    /// // Test race condition with custom task count
    /// await TestBarrier.executeConcurrently(taskCount: 50) {
    ///     someSharedResource.modify()
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - taskCount: The number of concurrent tasks to execute.
    ///   - block: The code to execute simultaneously across all tasks.
    /// - Throws: An error if any error is thrown by the block from any of the
    ///   tasks.
    static func executeConcurrently(
        taskCount: Int = TestBarrier.defaultTaskCount,
        _ block: @escaping @Sendable () async throws -> Void
    ) async throws {
        let barrier = TestBarrier(totalTasks: taskCount)
        let errorStorage = ErrorStorage()

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<taskCount {
                group.addTask {
                    await barrier.wait()

                    do {
                        try await block()
                    } catch {
                        await errorStorage.setError(error)
                    }
                }
            }
        }

        guard let error = await errorStorage.getError() else {
            return
        }

        throw error
    }
}

// MARK: - ErrorStorage

/// A thread-safe storage for capturing the first error that occurs during
/// concurrent task execution.
///
/// This actor ensures that when multiple tasks throw errors simultaneously,
/// only the first error is captured and stored. This is used by
/// `TestBarrier.executeConcurrently` to provide deterministic error handling
/// in race condition tests.
private actor ErrorStorage {

    // MARK: Properties

    /// The first error that was set, if any.
    private var error: (any Error)?

    // MARK: Error

    /// Sets the error if no error has been set previously.
    ///
    /// This method is thread-safe and will only store the first error that is
    /// passed to it. Subsequent calls with different errors will be ignored.
    ///
    /// - Parameter error: The error to store.
    func setError(_ error: any Error) {
        guard self.error == nil else {
            return
        }

        self.error = error
    }

    /// Returns the first error that was set, if any.
    ///
    /// - Returns: The first error that was stored, or `nil` if no error has
    ///   been set.
    func getError() -> (any Error)? {
        self.error
    }
}
