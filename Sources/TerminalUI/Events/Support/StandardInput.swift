import AsyncAlgorithms
import Dispatch

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif

struct StandardInput: AsyncSequence, Sendable {
  func makeAsyncIterator() -> AsyncMapSequence<AsyncStream<Void>, [Byte]>.Iterator {
    AsyncStream(DispatchSource.makeReadSource(fileDescriptor: STDIN_FILENO))
      .map {

        var bytes: [Byte] = []

        let size = 64
        var buffer: [UInt8] = Array(repeating: 0, count: size)
        var count: Int

        // Repeat if we fill up the buffer, to read all available byes.
        repeat {
          count = read(STDIN_FILENO, &buffer, size)
          guard count > 0 else { break }
          bytes.append(contentsOf: buffer.prefix(count).map(Byte.init(_:)))
        } while count == size

        return bytes
      }
      .makeAsyncIterator()
  }
}
