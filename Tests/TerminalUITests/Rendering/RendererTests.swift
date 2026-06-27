@testable import TerminalUI
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

  @Test func `one renderer draws across multiple frames`() {

    let canvas = TestCanvas(width: 0, height: 0)
    let renderer = Renderer(canvas: canvas, content: Color.red)

    renderer.render(event: WindowChange(size: Size(width: 1, height: 1)))
    #expect(Set(canvas.pixels.keys) == [
      Position(x: 1, y: 1)
    ])

    renderer.render(event: WindowChange(size: Size(width: 3, height: 1)))
    #expect(Set(canvas.pixels.keys) == [
      Position(x: 1, y: 1),
      Position(x: 2, y: 1),
      Position(x: 3, y: 1),
    ])
  }
}
