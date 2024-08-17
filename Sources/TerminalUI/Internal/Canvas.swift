
struct Canvas {

  var cursor: Cursor

  mutating func draw(_ pixel: Pixel, at position: Position) {
//    cursor.move(to: position)
//    cursor.setForegroundColor(pixel.foreground)
//    cursor.setBackgroundColor(pixel.background)
    cursor.write(pixel.content)
  }
}
