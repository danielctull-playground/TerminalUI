@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("BackgroundColor Tests", .tags(.viewModifier))
struct BackgroundColorTests {

  @Test("backgroundColor")
  func backgroundColor() {

    let text = Text("x")
      .backgroundColor(.blue)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", background: .blue),
    ])
  }
}
