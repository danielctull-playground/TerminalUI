import AttributeGraph

package protocol Canvas {
  func beginFrame()
  func draw(_ pixel: Pixel, at position: Position)
  func endFrame()
}
