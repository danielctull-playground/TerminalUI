import TerminalUI
import TerminalUITesting
import Testing

@Suite("ForEach", .tags(.view))
struct ForEachTests {

  @Test func `renders each element in order`() {

    let canvas = TestCanvas(width: 1, height: 3)
    canvas.render {
      VStack(spacing: 0) {
        ForEach(["a", "b", "c"], id: \.self) { letter in
          Text(letter)
        }
      }
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("a"),
      Position(x: 1, y: 2): Pixel("b"),
      Position(x: 1, y: 3): Pixel("c"),
    ])
  }
}
