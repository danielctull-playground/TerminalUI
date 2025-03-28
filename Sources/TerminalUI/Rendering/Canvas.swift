
package protocol Canvas {
  func draw(_ pixel: Pixel, at position: Position)
}

extension Canvas {

  package func render(size: Size, content: () -> some View) {
    content()
      .frame(width: size.width, height: size.height)
      ._render(in: Rect(origin: .origin, size: size), canvas: self)
  }
}

// MARK: - Translation

extension Canvas {
  func translateBy(x: Int, y: Int) -> some Canvas {
    TranslatedCanvas(base: self, x: x, y: y)
  }
}

private struct TranslatedCanvas<Base: Canvas>: Canvas {
  let base: Base
  let x: Int
  let y: Int

  func draw(_ pixel: Pixel, at position: Position) {
    let position = Position(x: x + position.x, y: y + position.y)
    base.draw(pixel, at: position)
  }
}
