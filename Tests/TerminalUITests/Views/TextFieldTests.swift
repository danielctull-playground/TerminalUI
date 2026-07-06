@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("TextField")
struct TextFieldTests {

  @Test func `key presses are rendered`() {

    struct Content: View {
      @State private var text = ""
      var body: some View {
        TextField(text: $text)
      }
    }

    let canvas = TestCanvas(width: 2, height: 1)
    let renderer = Renderer(canvas: canvas, content: Content())
    renderer.render(event: WindowChange(size: Size(width: 2, height: 1)))

    #expect(canvas.pixels == [:])

    renderer.render(event: KeyPress("h"))
    #expect(canvas.pixels == [
      Position(x: 2, y: 1): Pixel("h"),
    ])

    renderer.render(event: KeyPress("i"))
    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("h"),
      Position(x: 2, y: 1): Pixel("i"),
    ])
  }
}
