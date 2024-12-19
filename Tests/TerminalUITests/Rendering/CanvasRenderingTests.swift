@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Canvas Rendering")
struct CanvasRenderingTests {

  @Test("Center alignment")
  func center() {
    let canvas = TestCanvas(width: 3, height: 3)
    canvas.render {
      Text("A")
    }
    #expect(canvas.pixels == [
      Position(x: 2, y: 2): Pixel("A")
    ])
  }
}
