import TerminalUI
import TerminalUITesting
import Testing

@Suite("Renderer")
struct RendererTests {

  @Test func `height: zero`() {
    let canvas = TestCanvas(width: 3, height: 0)
    canvas.render {
      Color.red
    }
    #expect(canvas.pixels.isEmpty)
  }

  @Test func `width: zero`() {
    let canvas = TestCanvas(width: 0, height: 3)
    canvas.render {
      Color.red
    }
    #expect(canvas.pixels.isEmpty)
  }
}
