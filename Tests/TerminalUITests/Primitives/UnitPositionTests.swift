import TerminalUI
import Testing

@Suite("UnitPosition") struct UnitPositionTests {

  @Test("init", arguments: Array<(UnitPosition, Double, Double)>([
    (UnitPosition(x: 0.1, y: 0.2), 0.1, 0.2),
    (.topLeading,     0,   0),
    (.top,            0.5, 0),
    (.topTrailing,    1,   0),
    (.leading,        0,   0.5),
    (.center,         0.5, 0.5),
    (.trailing,       1,   0.5),
    (.bottomLeading,  0,   1),
    (.bottom,         0.5, 1),
    (.bottomTrailing, 1,   1),
  ]))
  func init_position(position: UnitPosition, x: Double, y: Double) {
    #expect(position.x == x)
    #expect(position.y == y)
  }
}
