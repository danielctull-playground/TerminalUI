import TerminalUI
import TerminalUITesting
import Testing

@Suite("TestCanvas")
struct TestCanvasTests {

  @Test func `CustomStringConvertible`() async throws {

    let canvas = TestCanvas(width: 5, height: 1)

    canvas.render {
      Text("hello")
    }

    #expect(canvas.description == "hello")
  }
}
