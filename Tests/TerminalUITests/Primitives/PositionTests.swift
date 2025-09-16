import TerminalUI
import Testing

@Suite("Position") struct PositionTests {

  @Test func `CustomStringConvertible`() {
    #expect(Position(x: 1, y: 2).description == #"Position(x: 1, y: 2)"#)
    #expect(Position(x: -3, y: -4).description == #"Position(x: -3, y: -4)"#)
  }

  @Test func `origin`() async throws {
    #expect(Position.origin.x == 1)
    #expect(Position.origin.y == 1)
  }
}
