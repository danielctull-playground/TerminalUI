@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Blinking", .tags(.viewModifier))
struct BlinkingTests {

  @Test("on")
  func on() {

    let text = Text("x")
      .blinking(true)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", blinking: .on),
    ])
  }

  @Test("off")
  func off() {

    let text = Text("x")
      .blinking(false)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", blinking: .off),
    ])
  }
}
