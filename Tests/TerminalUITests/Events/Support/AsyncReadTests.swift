import Testing
import Foundation
@testable import TerminalUI

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif

@Suite("AsyncRead")
struct AsyncReadTests {

  @Test(arguments: [50, 64, 100, 128, 500, 512, 1024])
  func stream(count: Int) async {
    let data = (1...count).map { _ in UInt8.random(in: 0...255) }
    let pipe = Pipe()
    let input = AsyncRead(fileHandle: pipe.fileHandleForReading)
    var iterator = input.makeAsyncIterator()
    pipe.fileHandleForWriting.write(Data(data))
    pipe.fileHandleForWriting.closeFile()
    let result = await iterator.next()
    #expect(result == data.map(Byte.init(_:)))
  }
}
