import AttributeGraph

public protocol Canvas {
  func draw(_ pixel: Pixel, at position: Position)
}
