import AttributeGraph

package protocol Canvas {
  func drawFrame(_ frame: () -> Void)
  func draw(_ pixel: Pixel, at position: Position)
}
