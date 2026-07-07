import AttributeGraph

package protocol Canvas {
  func draw(_ draw: (Frame) -> Void)
}

package struct Frame {

  private let _draw: (Pixel, Position) -> Void
  package init(_ draw: @escaping (Pixel, Position) -> Void) {
    _draw = draw
  }

  package func draw(_ pixel: Pixel, at position: Position) {
    _draw(pixel, position)
  }
}
