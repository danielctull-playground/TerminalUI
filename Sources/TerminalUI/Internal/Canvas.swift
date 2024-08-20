
struct Canvas {

  var size: Size
  var cursor: Cursor

  mutating func clear() {
    for x in 1..<size.width {
      for y in 1..<size.height {
        let position = Position(x: x, y: y)
        draw(Pixel(" "), at: position)
      }
    }
  }

  mutating func draw(_ pixel: Pixel, at position: Position) {
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
