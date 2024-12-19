
package protocol Canvas {
  func draw(_ pixel: Pixel, at position: Position)
}

extension Canvas {

  package func render(size proposedSize: ProposedSize, content: () -> some View) {
    let content = content()
    let size = content._size(for: proposedSize)
    let offsetX = Horizontal(size.width.distance(to: proposedSize.width) / 2)
    let offsetY = Vertical(size.height.distance(to: proposedSize.height) / 2)
    content._render(in: translateBy(x: offsetX, y: offsetY), size: size)
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
