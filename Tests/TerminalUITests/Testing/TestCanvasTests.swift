import TerminalUI
import TerminalUITesting
import Testing

@Suite("TestCanvas")
struct TestCanvasTests {

  @Test("CustomStringConvertible")
  func customStringConvertible() async throws {

    let canvas = TestCanvas(width: 5, height: 1)

    canvas.render {
      Text("hello")
    }

    #expect(canvas.description == "hello")
  }
}
