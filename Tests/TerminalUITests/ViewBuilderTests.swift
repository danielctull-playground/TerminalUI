import TerminalUI
import TerminalUITesting
import Testing

@Suite("ViewBuilder", .tags(.modifier))
struct ViewBuilderTests {

  private var canvas = TestCanvas(width: 10, height: 10)

  @Test func first() {

    canvas.render {
      Text("a")
    }

    #expect(canvas.pixels == [
      Position(x: 6, y: 6): Pixel("a"),
    ])
  }

  @Test func accumulated() {

    canvas.render {
      Text("a")
      Text("b")
    }

    #expect(canvas.pixels == [
      Position(x: 6, y: 5): Pixel("a"),
      Position(x: 6, y: 6): Pixel("b"),
    ])
  }
}
