@testable import TerminalUI
import Testing

@Suite("ProposedSize") struct ProposedSizeTests {

  @Test("init")
  func `init`() {
    let size = ProposedSize(width: 10, height: 8)
    #expect(size.width == 10)
    #expect(size.height == 8)
  }
}
