@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Strikethrough", .tags(.viewModifier))
struct StrikethroughTests {

  @Test("on")
  func on() {

    let text = Text("x")
      .strikethrough(true)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", strikethrough: .on),
    ])
  }

  @Test("off")
  func off() {

    let text = Text("x")
      .strikethrough(false)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", strikethrough: .off),
    ])
  }
}
