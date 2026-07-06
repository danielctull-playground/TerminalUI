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

  @Test func `multiple TextFields can be tabbed between`() {

    struct Content: View {
      @State private var a = ""
      @State private var b = ""
      var body: some View {
        VStack(spacing: 0) {
          TextField(text: $a)
          TextField(text: $b)
        }
      }
    }

    let canvas = TestCanvas(width: 2, height: 2)
    let renderer = Renderer(canvas: canvas, content: Content())
    renderer.render(event: WindowChange(size: Size(width: 2, height: 2)))

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

    renderer.render(event: KeyPress("\t")) // tab
    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("h"),
      Position(x: 2, y: 1): Pixel("i"),
    ])

    renderer.render(event: KeyPress("x"))
    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("h"),
      Position(x: 2, y: 1): Pixel("i"),
      Position(x: 2, y: 2): Pixel("x"),
    ])
  }
}
