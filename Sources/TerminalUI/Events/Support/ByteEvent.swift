
protocol ByteEvent: Event {
  init(parser: inout Parser<[Byte]>) throws
}

// MARK: - Standard Input Parsing

extension AsyncSequence where Self: Sendable, Element == [Byte] {

  func parsing<each E: ByteEvent>(
    _ type: repeat (each E).Type
  ) -> some Sendable & AsyncSequence<any Event, Failure> {

    flatMap { bytes in

      var parser = Parser(bytes)
      var events: [any Event] = []

      parse: while !parser.isFinished {
        for type in repeat (each type) {

          // Note the current index to allow the parser to be
          // reset if parsing the current event type fails.
          let index = parser.index

          do {
            let event = try type.init(parser: &parser)
            events.append(event)
            continue parse

          } catch {
            parser.index = index
          }
        }

        // If the byte can't be parsed, add it to
        // events and try from the following byte.
        events.append(try! parser.advance())
      }

      return events.async
    }
  }
}
