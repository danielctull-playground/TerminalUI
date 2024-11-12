@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Bold", .tags(.viewModifier))
struct BoldTests {

  @Test("on")
  func on() {

    let text = Text("x")
      .bold(true)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", bold: .on),
    ])
  }

  @Test("off")
  func off() {

    let text = Text("x")
      .bold(false)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", bold : .off),
    ])
  }
}
