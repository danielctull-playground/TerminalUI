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

    let screen = TestScreen(width: 3, height: 1)
    let renderer = Renderer(screen: screen, content: Content())
    renderer.render(event: WindowSize(size: Size(width: 3, height: 1)))

    #expect(screen.cells == [
      Position(x: 2, y: 1): Cell("_"),
    ])

    renderer.render(event: KeyPress("h"))
    #expect(screen.cells == [
      Position(x: 1, y: 1): Cell("h"),
      Position(x: 2, y: 1): Cell("_"),
    ])

    renderer.render(event: KeyPress("i"))
    #expect(screen.cells == [
      Position(x: 1, y: 1): Cell("h"),
      Position(x: 2, y: 1): Cell("i"),
      Position(x: 3, y: 1): Cell("_"),
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

    let screen = TestScreen(width: 3, height: 2)
    let renderer = Renderer(screen: screen, content: Content())
    renderer.render(event: WindowSize(size: Size(width: 3, height: 2)))

    #expect(screen.cells == [
      Position(x: 2, y: 1): Cell("_"),
    ])

    renderer.render(event: KeyPress("h"))
    #expect(screen.cells == [
      Position(x: 1, y: 1): Cell("h"),
      Position(x: 2, y: 1): Cell("_"),
    ])

    renderer.render(event: KeyPress("i"))
    #expect(screen.cells == [
      Position(x: 1, y: 1): Cell("h"),
      Position(x: 2, y: 1): Cell("i"),
      Position(x: 3, y: 1): Cell("_"),
    ])

    renderer.render(event: KeyPress("\t")) // tab
    #expect(screen.cells == [
      Position(x: 1, y: 1): Cell("h"),
      Position(x: 2, y: 1): Cell("i"),
      Position(x: 2, y: 2): Cell("_"),
    ])

//    screen.cells = [:]
    renderer.render(event: KeyPress("x"))
    #expect(screen.cells == [
      Position(x: 1, y: 1): Cell("h"),
      Position(x: 2, y: 1): Cell("i"),
      Position(x: 1, y: 2): Cell("x"),
      Position(x: 2, y: 2): Cell("_"),
    ])
  }
}
