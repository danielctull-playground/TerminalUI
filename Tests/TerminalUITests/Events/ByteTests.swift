@testable import TerminalUI
import Testing

@Suite("Byte")
struct ByteTests {

  @Test func comparable() {
    #expect(Byte(1) < Byte(2))
    #expect(Byte(2) > Byte(1))
    #expect(Byte(1) <= Byte(1))
    #expect(Byte(1) <= Byte(2))
    #expect(Byte(1) >= Byte(1))
    #expect(Byte(2) >= Byte(1))
  }

  @Test func customStringConvertible() {
    #expect(Byte(0x41).description == #""A" (0x41)"#)
    #expect(Byte(0x5C).description == #""\" (0x5C)"#)
    #expect(Byte(0xFF).description == #""ÿ" (0xFF)"#)
  }

  @Test func equatable() {
    #expect(Byte(1) == Byte(1))
    #expect(Byte(1) != Byte(2))
  }

  @Test func expressibleByIntegerLiteral() {
    #expect(1 as Byte == Byte(1))
    #expect(3 as Byte == Byte(3))
  }
}
