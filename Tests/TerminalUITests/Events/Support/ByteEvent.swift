@testable import TerminalUI

extension ByteEvent {

  init(_ string: String) throws {
    try self.init(string.utf8.map(Byte.init(_:)))
  }

  init(_ bytes: [Byte]) throws {
    var parser = Parser(bytes)
    try self.init(parser: &parser)
  }
}
