import TerminalUI
import Testing

@Suite("Cell")
struct CellTests {

  @Test func `CustomStringConvertible`() {
    #expect(Cell("a").description == #"Cell("a")"#)
    #expect(Cell("z").description == #"Cell("z")"#)
  }
}
