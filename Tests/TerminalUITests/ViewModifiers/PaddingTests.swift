@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Padding", .tags(.viewModifier))
struct PaddingTests {

  let canvas = TestCanvas()
  let view = Color.blue
  let pixel = Pixel(" ", background: .blue)

  @Test("edge insets")
  func edgeInsets() {

    canvas.render(size: Size(width: 8, height: 6)) {
      view.padding(EdgeInsets(top: 1, leading: 2, bottom: 3, trailing: 4))
    }

    #expect(canvas.pixels == [
      Position(x: 3, y: 2): pixel,
      Position(x: 4, y: 2): pixel,
      Position(x: 3, y: 3): pixel,
      Position(x: 4, y: 3): pixel,
    ])
  }
}
