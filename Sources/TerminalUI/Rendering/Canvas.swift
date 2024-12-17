
package protocol Canvas {
  func draw(_ pixel: Pixel, at position: Position)
}

extension Canvas {

  package func render(size: Size, content: () -> some View) {
    content()._render(in: self, size: size)
  }
}
