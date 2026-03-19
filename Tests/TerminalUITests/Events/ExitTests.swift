@testable import TerminalUI
import Testing

@Suite("Exit")
struct ExitTests {

  @Test func customStringConvertible() throws {
    var parser = Parser([0x03] as [Byte])
    let exit = try Exit(parser: &parser)
    #expect(exit.description == "Exit")
  }

  @Test func valid() {
    #expect(throws: Never.self) {
      var parser = Parser([0x03] as [Byte])
      _ = try Exit(parser: &parser)
    }
  }

  @Test(arguments: [[0x01], [0x02], [0x04], [0x05]] as [[Byte]])
  func invalid(bytes: [Byte]) {
    #expect(throws: Exit.Invalid.self) {
      var parser = Parser(bytes)
      _ = try Exit(parser: &parser)
    }
  }
}
