
package protocol Canvas {
  func draw(_ pixel: Pixel, at position: Position)
}

extension Canvas {

  package func render(size: ProposedSize, content: () -> some View) {
    let content = content()
    let size = content._size(for: size)
    content._render(in: self, size: size)
  }
}
