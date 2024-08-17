
struct Canvas {

  var cursor: Cursor

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
