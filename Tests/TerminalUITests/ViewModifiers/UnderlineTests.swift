@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Underline", .tags(.viewModifier))
struct UnderlineTests {

  @Test("on")
  func on() {

    let text = Text("x")
      .underline(true)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", underline: .on),
    ])
  }

  @Test("off")
  func off() {

    let text = Text("x")
      .underline(false)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", underline: .off),
    ])
  }
}
