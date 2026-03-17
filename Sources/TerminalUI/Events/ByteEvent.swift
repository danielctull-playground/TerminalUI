
protocol ByteEvent: Event {
  init(parsing: [Byte]) throws
}

struct InsufficientData: Error {}

struct MultipleErrors: Error {
  let errors: [Error]
}

extension AsyncSequence where Self: Sendable, AsyncIterator: Sendable, Element == Byte {

  func byteEvents<each E: ByteEvent>(of event: repeat (each E).Type) -> some Sendable & AsyncSequence<any Event, Failure> {
    ByteEventParser(of: repeat each event, in: self)
  }
}

/// Stateful byte-by-byte parser that emits ``Byte`` or ``ByteEvent`` events.
struct ByteEventParser<Source>: AsyncSequence, Sendable
  where
  Source: AsyncSequence,
  Source: Sendable,
  Source.AsyncIterator: Sendable,
  Source.Element == Byte
{
  typealias Failure = Source.Failure
  private let source: Source
  private let parse: @Sendable ([Byte]) throws -> any ByteEvent

  init<each Event: ByteEvent>(of event: repeat (each Event).Type, in source: Source) {
    self.source = source
    self.parse = {

      var errors: [Error] = []

      for event in repeat (each event) {
        do {
          return try event.init(parsing: $0)
        } catch {
          errors.append(error)
        }
      }

      if errors.contains(where: { $0 is InsufficientData }) {
        throw InsufficientData()
      } else {
        throw MultipleErrors(errors: errors)
      }
    }
  }

  func makeAsyncIterator() -> Iterator {
    Iterator(source: source.makeAsyncIterator(), parse: parse)
  }

  struct Iterator: AsyncIteratorProtocol {

    var source: Source.AsyncIterator
    let parse: ([Byte]) throws -> any ByteEvent
    var buffer: [Byte] = []

    mutating func next(isolation actor: isolated (any Actor)?) async throws(Source.AsyncIterator.Failure) -> (any Event)? {

      var status: Error = InsufficientData()

      loop: while status is InsufficientData {

        do {
          return try parse(buffer)
        } catch {
          status = error
        }

        if let byte = try await source.next(timeout: .milliseconds(2)) {
          buffer.append(byte)
        } else {
          break loop
        }
      }

      if let byte = buffer.dropFirst().first {
        return byte
      }

      return try await source.next(isolation: actor)
    }
  }
}
