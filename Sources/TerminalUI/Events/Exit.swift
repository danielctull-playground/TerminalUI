import Dispatch

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

struct Exit: ByteEvent {
  struct Invalid: Error {}
  init(parser: inout Parser<[Byte]>) throws {
    let byte = try parser.advance()
    guard byte == 0x03 else { throw Invalid() }
  }
}

extension Exit: CustomStringConvertible {
  var description: String { "Exit" }
}
