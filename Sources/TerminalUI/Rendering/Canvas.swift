
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

// MARK: - Translation

extension Canvas {
  func translateBy(x: Horizontal, y: Vertical) -> some Canvas {
    TranslatedCanvas(base: self, x: x, y: y)
  }
}

private struct TranslatedCanvas<Base: Canvas>: Canvas {
  let base: Base
  let x: Horizontal
  let y: Vertical

  func draw(_ pixel: Pixel, at position: Position) {
    let position = Position(x: x + position.x, y: y + position.y)
    base.draw(pixel, at: position)
  }
}
