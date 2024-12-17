import TerminalUI
import Testing

public struct TestCanvas: Canvas {
  @Mutable package var pixels: [Position: Pixel] = [:]
  private let size: Size
  public init(width: Horizontal, height: Vertical) {
    size = Size(width: width, height: height)
  }
  public func draw(_ pixel: Pixel, at position: Position) {
    pixels[position] = pixel
  }
}

extension TestCanvas {
  public func render(content: () -> some View) {
    content()._render(in: self, size: size)
  }
}
