import TerminalUI
import TerminalUITesting
import Testing

@Suite("TestScreen")
struct TestScreenTests {

  @Test func `CustomStringConvertible`() async throws {

    let screen = TestScreen(width: 5, height: 1)

    screen.render {
      Text("hello")
    }

    #expect(screen.description == "hello")
  }
}
