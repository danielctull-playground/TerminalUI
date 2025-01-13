import TerminalUI
import Testing

@Suite("Size") struct SizeTests {

  @Test("init(width:height:)")
  func init_width_height() {
    let size = Size(width: 10, height: 8)
    #expect(size.width == 10)
    #expect(size.height == 8)
  }
}
