import TerminalUI
import Testing

public struct TestCanvas: Canvas {
  @Mutable package var pixels: [Position: Pixel] = [:]
  public init() {}
  public func draw(_ pixel: Pixel, at position: Position) {
    pixels[position] = pixel
  }
}

extension TestCanvas {
  public func render(size: Size, content: () -> some View) {
    content()._render(in: self, size: size)
  }
}

extension View {

  package func expect(_ expected: [Position: Pixel]) {
    let canvas = TestCanvas()
    _render(in: canvas, size: Size(width: 10, height: 10))
    #expect(canvas.pixels == expected)
  }
}
