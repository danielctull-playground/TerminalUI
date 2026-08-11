@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("OnKeyPress")
struct OnKeyPressTests {

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

    renderer.render(event: KeyPress("x"))
    #expect(received == [KeyPress("x")])
  }
}
