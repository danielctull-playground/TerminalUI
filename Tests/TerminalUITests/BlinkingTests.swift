@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Blinking Tests", .tags(.viewModifier))
struct BlinkingTests {

  @Test("blinking = on")
  func on() {

    let text = Text("x")
      .blinking(true)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", blinking: .on),
    ])
  }

  @Test("blinking = off")
  func off() {

    let text = Text("x")
      .blinking(false)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", blinking: .off),
    ])
  }
}
