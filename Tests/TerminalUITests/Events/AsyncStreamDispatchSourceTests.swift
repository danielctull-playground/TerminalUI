@preconcurrency import Dispatch
@testable import TerminalUI
import Testing

@Suite("AsyncStream+DispatchSource")
struct AsyncStreamDispatchSourceTests {

  @Test func `dispatch source triggers`() async {

    let source = DispatchSource.makeTimerSource()
    source.schedule(deadline: .now(), repeating: .milliseconds(1))

    var count = 0

    for await _ in AsyncStream(source) {
      count += 1
      if count == 4 { break }
    }

    #expect(count == 4)
  }

  @Test func `cancelling stream cancels the dispatch source`() async {

    let source = DispatchSource.makeTimerSource()
    source.schedule(deadline: .distantFuture)

    let (stream, continuation) = AsyncStream<Void>.makeStream()
    var signal = stream.makeAsyncIterator()

    let task = Task {
      for await _ in AsyncStream(source) {
        continuation.yield()
      }
      continuation.finish() // AsyncStream(source) is finished.
    }

    task.cancel()

    _ = await signal.next()
    #expect(source.isCancelled)
  }

  @Test func `cancelling dispatch source finishes the stream`() async {

    let source = DispatchSource.makeTimerSource()
    source.schedule(deadline: .distantFuture)

    var iterator = AsyncStream(source).makeAsyncIterator()

    source.cancel()

    #expect(await iterator.next() == nil)
  }
}
