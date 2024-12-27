import TerminalUI
import TerminalUITesting
import Testing

@Suite("EmptyView", .tags(.view, .emptyView))
struct EmptyViewTests {

  @Test("render")
  func render() {
    let canvas = TestCanvas(width: 3, height: 3)
    EmptyView()._render(in: canvas, size: Size(width: 3, height: 3))
    #expect(canvas.pixels == [:])
  }


  @Test("size")
  func size() {
    let size = EmptyView()._size(for: ProposedSize(width: 100, height: 100))
    #expect(size == nil)
  }
}
