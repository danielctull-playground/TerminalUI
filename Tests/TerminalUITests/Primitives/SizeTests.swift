import TerminalUI
import Testing

@Suite("Size") struct SizeTests {

  @Test func `init(width:height:)`() {
    let size = Size(width: 10, height: 8)
    #expect(size.width == 10)
    #expect(size.height == 8)
  }
}
