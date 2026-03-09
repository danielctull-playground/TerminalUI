import AttributeGraph

package protocol Canvas {
  func beginUpdates()
  func endUpdates()
  func draw(_ pixel: Pixel, at position: Position)
}

extension Canvas {
  package func beginUpdates() {}
  package func endUpdates() {}
}
