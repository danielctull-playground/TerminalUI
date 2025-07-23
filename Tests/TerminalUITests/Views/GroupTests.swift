import TerminalUI
import TerminalUITesting
import Testing

@Suite("Group", .tags(.view))
struct GroupTests {

  private var canvas = TestCanvas(width: 10, height: 10)

  @Test func test() {

    canvas.render {
      Group {
        Text("a")
        Text("b")
      }
      .padding(1)
    }

    #expect(canvas.pixels == [
      Position(x: 6, y: 4): Pixel("a"),
      Position(x: 6, y: 7): Pixel("b"),
    ])
  }
}
