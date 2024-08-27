
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

  init() {
    var cursor = Cursor()
    self.init { pixel, position in
      cursor.move(to: position)
      cursor.setForegroundColor(pixel.foreground)
      cursor.setBackgroundColor(pixel.background)
      cursor.setBold(pixel.bold)
      cursor.setItalic(pixel.italic)
      cursor.setUnderline(pixel.underline)
      cursor.setBlinking(pixel.blinking)
      cursor.setInverse(pixel.inverse)
      cursor.setHidden(pixel.hidden)
      cursor.setStrikethrough(pixel.strikethrough)
      cursor.write(pixel.content)
    }
  }
}
