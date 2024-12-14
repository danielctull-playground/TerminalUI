@testable import TerminalUI
import Testing

package struct TestCanvas: Canvas {
  @Mutable package var pixels: [Position: Pixel] = [:]
  package init() {}
  package func draw(_ pixel: Pixel, at position: Position) {
    pixels[position] = pixel
  }
}

extension View {

  package func expect(_ expected: [Position: Pixel]) {
    let canvas = TestCanvas()
    _render(in: canvas)
    #expect(canvas.pixels == expected)
  }
}
