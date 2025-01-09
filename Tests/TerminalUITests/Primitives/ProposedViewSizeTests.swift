import TerminalUI
import Testing

@Suite("ProposedViewSize")
struct ProposedViewSizeTests {

  @Test("init")
  func `init`() {
    let size = ProposedViewSize(width: 10, height: 8)
    #expect(size.width == 10)
    #expect(size.height == 8)
  }

  @Test("replacingUnspecifiedDimensions")
  func replacingUnspecifiedDimensions() {
    let size = ProposedViewSize(width: 20, height: 30)
      .replacingUnspecifiedDimensions()
    #expect(size.width == 20)
    #expect(size.height == 30)
  }

  @Test("replacingUnspecifiedDimensions: nil")
  func replacingUnspecifiedDimensions_nil() {
    let size = ProposedViewSize(width: nil, height: nil)
      .replacingUnspecifiedDimensions()
    #expect(size.width == 10)
    #expect(size.height == 10)
  }

  @Test("replacingUnspecifiedDimensions: size")
  func replacingUnspecifiedDimensions_size() {
    let size = ProposedViewSize(width: nil, height: nil)
      .replacingUnspecifiedDimensions(by: Size(width: 40, height: 50))
    #expect(size.width == 40)
    #expect(size.height == 50)
  }
}
