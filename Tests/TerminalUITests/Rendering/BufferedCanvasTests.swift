@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("BufferedCanvas")
struct BufferedCanvasTests {

  @Test func d() async throws {

    let canvas = TestCanvas(width: 0, height: 0)
    let buffered = canvas.buffered()

    buffered.draw {
      $0.draw(Pixel("a"), at: Position(x: 1, y: 1))
      $0.draw(Pixel("b"), at: Position(x: 2, y: 1))
      $0.draw(Pixel("c"), at: Position(x: 3, y: 1))
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("a"),
      Position(x: 2, y: 1): Pixel("b"),
      Position(x: 3, y: 1): Pixel("c"),
    ])

    buffered.draw {
      $0.draw(Pixel("a"), at: Position(x: 1, y: 1))
      $0.draw(Pixel("B"), at: Position(x: 2, y: 1))
      $0.draw(Pixel("c"), at: Position(x: 3, y: 1))
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 1): Pixel("B"),
    ])
  }
}
