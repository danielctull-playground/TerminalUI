@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Hidden", .tags(.modifier))
struct HiddenTests {

  @Test(arguments: [
    (true,  "."),
    (false, "a"),
  ])
  func `Text Output`(hidden: Bool, expected: String) {

    let screen = TestScreen(width: 1, height: 1)
    screen.render {
      Text("a").hidden(hidden)
    }

    #expect(screen.buffer.description == expected)
  }

  @Test func `toggling hidden clears a prior frame`() {

    struct Content: View {
      @Environment(\.windowSize) private var windowSize
      var body: some View {
        Text("a")
          .hidden(windowSize.size.height > 1)
      }
    }

    let screen = TestScreen(width: 1, height: 1)
    let renderer = Renderer(screen: screen, content: Content())

    renderer.render(event: WindowSize(size: Size(width: 1, height: 1)))
    #expect(screen.buffer.description == "a")

    renderer.render(event: WindowSize(size: Size(width: 1, height: 2)))
    #expect(screen.buffer.description == """
      .
      .
      """)
  }
}
