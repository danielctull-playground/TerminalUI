@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("OnKeyPress")
struct OnKeyPressTests {

  @Test func `focused alone does not make a view tabbable`() {

    var received: [KeyPress] = []

    struct Content: View {
      @FocusState private var isFocused: Bool
      let received: (KeyPress) -> Void

      var body: some View {
        Text("X")
          .focused($isFocused)
          .onKeyPress { keyPress in
            received(keyPress)
            return .handled
          }
      }
    }

    let screen = TestScreen(width: 1, height: 1)
    let renderer = Renderer(screen: screen, content: Content { received.append($0) })

    renderer.render(event: WindowSize(size: Size(width: 1, height: 1)))
    renderer.render(event: KeyPress.tab)
    renderer.render(event: KeyPress("x"))

    #expect(received == [])
  }

  @Test func `non-focusable view is skipped by tab`() {

    var received: [String] = []

    let screen = TestScreen(width: 2, height: 1)
    let renderer = Renderer(
      screen: screen,
      content: HStack(spacing: 0) {
        Text("A")
          .focusable(false)
          .onKeyPress { _ in
            received.append("A")
            return .handled
          }
        Text("B")
          .focusable()
          .onKeyPress { _ in
            received.append("B")
            return .handled
          }
      }
    )

    renderer.render(event: WindowSize(size: Size(width: 2, height: 1)))
    renderer.render(event: KeyPress.tab)
    renderer.render(event: KeyPress("x"))

    #expect(received == ["B"])
  }

  @Test func `focused view receives a key press`() {

    var received: [KeyPress] = []

    let screen = TestScreen(width: 1, height: 1)
    let renderer = Renderer(
      screen: screen,
      content: Text("X")
        .focusable()
        .onKeyPress { keyPress in
          received.append(keyPress)
          return .handled
        }
    )

    // Trigger render
    renderer.render(event: WindowSize(size: Size(width: 1, height: 1)))

    // Tab to focus on the focusable view.
    renderer.render(event: KeyPress.tab)

    renderer.render(event: KeyPress("x"))
    #expect(received == [KeyPress("x")])
  }
}
