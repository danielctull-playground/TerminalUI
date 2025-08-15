@testable import TerminalUI
import TerminalUITesting
import Testing

@MainActor
@Suite("State")
struct StateTests {

  @Test("reading") func reading() {

    struct TestView: View {
      @State var value = "hello"
      var body: some View {
        Text(value)
      }
    }

    let canvas = TestCanvas(width: 5, height: 3)
    canvas.render {
      TestView()
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 2): Pixel("h"),
      Position(x: 2, y: 2): Pixel("e"),
      Position(x: 3, y: 2): Pixel("l"),
      Position(x: 4, y: 2): Pixel("l"),
      Position(x: 5, y: 2): Pixel("o"),
    ])
  }
}
