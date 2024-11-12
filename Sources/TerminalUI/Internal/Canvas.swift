
struct Canvas {

  private let draw: (Pixel, Position) -> Void
  init(draw: @escaping (Pixel, Position) -> Void) {
    self.draw = draw
  }

  func draw(_ pixel: Pixel, at position: Position) {
    draw(pixel, position)
  }
}

extension Canvas {

  init(_ output: some TextOutputStream) {
    var output = output
    self.init { pixel, position in
      output.move(to: position)
      output.setForegroundColor(pixel.foreground)
      output.setBackgroundColor(pixel.background)
      output.setBold(pixel.bold)
      output.setItalic(pixel.italic)
      output.setUnderline(pixel.underline)
      output.setBlinking(pixel.blinking)
      output.setInverse(pixel.inverse)
      output.setHidden(pixel.hidden)
      output.setStrikethrough(pixel.strikethrough)
      output.write(pixel.content)
    }
  }
}
