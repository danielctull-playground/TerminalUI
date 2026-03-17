import AsyncExtensions
import Clocks
import Foundation
@testable import TerminalUI
import Testing

@Suite("AsyncIterator+timeout")
struct AsyncIteratorTimeoutTests {

  private let clock = TestClock()

  @Test func `element arrives before timeout`() async throws {

    let channel = AsyncBufferedChannel<Int>()
    var iterator = channel.makeAsyncIterator()

    let task = Task {
      await iterator.next(timeout: .seconds(5), clock: clock)
    }

    channel.send(42)

    #expect(await task.value == 42)
  }

  @Test func `timeout occurs before element arrives`() async throws {

    let channel = AsyncBufferedChannel<Int>()
    var iterator = channel.makeAsyncIterator()

    let task = Task {
      await iterator.next(timeout: .seconds(5), clock: clock)
    }

    await clock.advance(by: .seconds(5))
    channel.send(42)

    #expect(await task.value == nil)
  }

  @Test func `timeout doesn't prevent read of next elements`() async throws {

    let channel = AsyncBufferedChannel<Int>()
    var iterator = channel.makeAsyncIterator()

    struct Result: Equatable, Sendable {
      let first: Int?
      let second: Int?
    }

    let task = Task {
      let first = await iterator.next(timeout: .seconds(5), clock: clock)
      let second = await iterator.next()
      return Result(first: first, second: second)
    }

    await clock.advance(by: .seconds(5))
    channel.send(42)

    let result = await task.value
    #expect(result.first == nil)
    #expect(result.second == 42)
  }

  @Test func `source finishes before timeout`() async throws {

    let channel = AsyncBufferedChannel<Int>()
    var iterator = channel.makeAsyncIterator()

    channel.finish()

    let task = Task {
      await iterator.next(timeout: .seconds(5), clock: clock)
    }

    #expect(await task.value == nil)
  }

  @Test func `failure in source iterator is thrown up`() async throws {

    struct Failure: Error, Equatable {
      let value = UUID().uuidString
    }

    let channel = AsyncThrowingBufferedChannel<Int, Error>()
    var iterator = channel.makeAsyncIterator()

    let task = Task {
      try await iterator.next(timeout: .seconds(5), clock: clock)
    }

    let failure = Failure()
    channel.fail(failure)

    let result = try await #require(throws: Failure.self) { try await task.value }
    #expect(result == failure)
  }

  @Test func `timeout duration resets for each call`() async throws {

    let channel = AsyncBufferedChannel<Int>()
    var iterator = channel.makeAsyncIterator()

    channel.send(1)
    channel.send(2)
    channel.send(3)
    channel.finish()

    #expect(await iterator.next(timeout: .seconds(5), clock: clock) == 1)
    await clock.advance(by: .seconds(5))
    #expect(await iterator.next(timeout: .seconds(5), clock: clock) == 2)
    await clock.advance(by: .seconds(5))
    #expect(await iterator.next(timeout: .seconds(5), clock: clock) == 3)
    await clock.advance(by: .seconds(5))
    #expect(await iterator.next(timeout: .seconds(5), clock: clock) == nil)
  }
}
