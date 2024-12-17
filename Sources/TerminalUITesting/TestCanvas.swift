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
