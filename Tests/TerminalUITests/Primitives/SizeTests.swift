@testable import TerminalUI
import Testing

@Suite("Size") struct SizeTests {

  @Test("init(width:height:)")
  func `init`() {
    let size = Size(width: 10, height: 8)
    #expect(size.width == 10)
    #expect(size.height == 8)
  }

  @Test("init(proposedSize)")
  func init_proposedSize() {
    let proposed = ProposedSize(width: 11, height: 18)
    let size = Size(proposed)
    #expect(size.width == 11)
    #expect(size.height == 18)
  }
}
