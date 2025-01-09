@testable import TerminalUI
import Testing

@Suite("ProposedViewSize")
struct ProposedViewSizeTests {

  @Test("init")
  func `init`() {
    let size = ProposedViewSize(width: 10, height: 8)
    #expect(size.width == 10)
    #expect(size.height == 8)
  }
}
