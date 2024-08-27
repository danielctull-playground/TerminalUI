
class Canvas {

  private var size: Size
  private var cursor: Cursor

  init(size: Size) {
    self.size = size
    self.cursor = Cursor()
  }

  func draw(_ pixel: Pixel, at position: Position) {
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
