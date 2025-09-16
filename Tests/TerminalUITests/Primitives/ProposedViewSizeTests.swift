import TerminalUI
import Testing

@Suite("ProposedViewSize")
struct ProposedViewSizeTests {

  @Test func `init(width:height:)`() {
    let size = ProposedViewSize(width: 10, height: 8)
    #expect(size.width == 10)
    #expect(size.height == 8)
  }

  @Test func `init(size:)`() {
    let size = Size(width: .random, height: .random)
    let proposal = ProposedViewSize(size)
    #expect(proposal.width == size.width)
    #expect(proposal.height == size.height)
  }

  @Test func `replacingUnspecifiedDimensions`() {
    let size = ProposedViewSize(width: 20, height: 30)
      .replacingUnspecifiedDimensions()
    #expect(size.width == 20)
    #expect(size.height == 30)
  }

  @Test func `replacingUnspecifiedDimensions: nil`() {
    let size = ProposedViewSize(width: nil, height: nil)
      .replacingUnspecifiedDimensions()
    #expect(size.width == 10)
    #expect(size.height == 10)
  }

  @Test func `replacingUnspecifiedDimensions: size`() {
    let size = ProposedViewSize(width: nil, height: nil)
      .replacingUnspecifiedDimensions(by: Size(width: 40, height: 50))
    #expect(size.width == 40)
    #expect(size.height == 50)
  }
}
