
protocol ByteEvent: Event {
  init(parsing: [Byte]) throws
}

extension ByteEvent {

  func checkTrailingBytes(_ bytes: Optional<some Collection<Byte>>) throws {
    if let bytes, !bytes.isEmpty {
      throw TrailingBytes(event: self, bytes: Array(bytes))
    }
  }
}

struct TrailingBytes: Error {
  let event: any ByteEvent
  let bytes: [Byte]
}

// MARK: - Standard Input Parsing

extension AsyncSequence where Element == [Byte] {

  func parsing<each E: ByteEvent>(
    _ type: repeat (each E).Type
  ) -> some AsyncSequence<any Event, Failure> {

    flatMap { bytes in

      var bytes = bytes
      var events: [any Event] = []

      parse: while !bytes.isEmpty {

        for type in repeat (each type) {
          do {
            events.append(try type.init(parsing: bytes))
            bytes.removeAll()

          } catch let trailing as TrailingBytes {
            events.append(trailing.event)
            bytes = trailing.bytes
            continue parse

          } catch {
            continue
          }
        }

        events.append(contentsOf: bytes)
        bytes.removeAll()
      }

      return events.async
    }
  }
}
