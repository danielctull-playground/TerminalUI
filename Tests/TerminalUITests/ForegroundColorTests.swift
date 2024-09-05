@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("ForegroundColor", .tags(.viewModifier))
struct ForegroundColorTests {

  @Test("foregroundColor")
  func foregroundColor() {

    let text = Text("x")
      .foregroundColor(.blue)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", foreground: .blue),
    ])
  }
}
