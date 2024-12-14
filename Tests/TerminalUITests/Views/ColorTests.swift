@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Color", .tags(.view))
struct ColorTests {

  @Test("Color displays correctly")
  func display() {

    let canvas = TestCanvas()

    canvas.render(size: Size(width: 3, height: 3)) {
      Color.red
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel(" ", background: .red),
      Position(x: 2, y: 1): Pixel(" ", background: .red),
      Position(x: 3, y: 1): Pixel(" ", background: .red),
      Position(x: 1, y: 2): Pixel(" ", background: .red),
      Position(x: 2, y: 2): Pixel(" ", background: .red),
      Position(x: 3, y: 2): Pixel(" ", background: .red),
      Position(x: 1, y: 3): Pixel(" ", background: .red),
      Position(x: 2, y: 3): Pixel(" ", background: .red),
      Position(x: 3, y: 3): Pixel(" ", background: .red),
    ])
  }
}
