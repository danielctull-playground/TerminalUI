@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Hidden Tests", .tags(.viewModifier))
struct HiddenTests {

  @Test("hidden = on")
  func on() {

    let text = Text("x")
      .hidden(true)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", hidden: .on),
    ])
  }

  @Test("hidden = off")
  func off() {

    let text = Text("x")
      .hidden(false)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", hidden: .off),
    ])
  }
}
