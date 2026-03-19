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
        let size = 64
        var buffer: [UInt8] = Array(repeating: 0, count: size)
        let readCount = read(STDIN_FILENO, &buffer, buffer.count)
        return buffer
          .prefix(readCount)
          .map(Byte.init(_:))
      }
      .makeAsyncIterator()
  }
}
