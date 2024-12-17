import TerminalUI
import Testing

@Suite("Position") struct PositionTests {

  @Test("origin")
  func origin() async throws {
    #expect(Position.origin.x == 1)
    #expect(Position.origin.y == 1)
  }
}
