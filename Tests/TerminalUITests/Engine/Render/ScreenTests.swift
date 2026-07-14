@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Screen")
struct ScreenTests {

  @Test func `Drawing with default values`() {
    let screen = TextOutputScreen(output: .memory)
    screen.draw([Position(x: 2, y: 1): Cell("a")])
    #expect(screen.output.controlSequences == [
      "[39;49;22;23;24;25;27;28;29m",
      "[1;2Ha", // Position + content
    ])
  }

  @Test func `Center alignment`() {
    let screen = TestScreen(width: 3, height: 3)
    screen.render {
      Text("A")
    }
    #expect(screen.cells == [
      Position(x: 2, y: 2): Cell("A")
    ])
  }
}
