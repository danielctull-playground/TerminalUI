import AsyncAlgorithms
@preconcurrency import Dispatch
import Foundation

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif

struct AsyncRead: AsyncSequence, Sendable {

  let fileHandle: FileHandle

  func makeAsyncIterator() -> AsyncStream<[Byte]>.Iterator {
    AsyncStream<[Byte]> { continuation in

      let source = DispatchSource.makeReadSource(fileDescriptor: fileHandle.fileDescriptor)

      source.setEventHandler {

        var bytes: [Byte] = []

        let size = 64
        var buffer: [Byte] = Array(repeating: 0, count: size)
        var count: Int

        // Repeat if we fill up the buffer, to read all available byes.
        repeat {
          count = read(fileHandle.fileDescriptor, &buffer, size)
          guard count > 0 else { break }
          bytes.append(contentsOf: buffer.prefix(count))
        } while count == size

        guard !bytes.isEmpty else { return }

        continuation.yield(bytes)
      }

      source.setCancelHandler {
        continuation.finish()
      }

      continuation.onTermination = { _ in
        source.cancel()
      }

      source.resume()
    }
    .makeAsyncIterator()
  }
}
