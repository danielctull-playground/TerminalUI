@testable import TerminalUI
import Testing

@Suite("EventStream")
struct EventStreamTests {

  struct E: Equatable, Event, ExpressibleByIntegerLiteral, Hashable {
    let value: Int
    init(integerLiteral value: IntegerLiteralType) {
      self.value = value
    }
  }

  @Test func first() async throws {
    let expected: [E] = [1, 2, 3]

    @EventStream var stream: some AsyncSequence<any Event, any Error> {
      expected.async
    }

    var collected: [E] = []

    for try await event in stream {
      if let e = event as? E {
        collected.append(e)
      }
    }

    #expect(collected == expected)
  }

  @Test func accumulated() async throws {
    let first: [E] = [1, 2, 3]
    let second: [E] = [4, 5, 6, 7]

    @EventStream var stream: some AsyncSequence<any Event, any Error> {
      first.async
      second.async
    }

    var collected: [E] = []

    for try await event in stream {
      if let e = event as? E {
        collected.append(e)
      }
    }

    #expect(
      Set(collected).map(\.value).sorted() ==
      Set(first + second).map(\.value).sorted()
    )
  }
}
