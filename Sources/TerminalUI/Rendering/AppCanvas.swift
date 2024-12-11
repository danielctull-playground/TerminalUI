
struct AppCanvas<Output: TextOutputStream>: Canvas {
  @Mutable var output: Output

  func draw(_ pixel: Pixel, at position: Position) {
    output.write(pixel.foreground.foreground)
    output.write(pixel.background.background)
    output.write(pixel.bold.controlSequence)
    output.write(pixel.italic.controlSequence)
    output.write(pixel.underline.controlSequence)
    output.write(pixel.blinking.controlSequence)
    output.write(pixel.inverse.controlSequence)
    output.write(pixel.hidden.controlSequence)
    output.write(pixel.strikethrough.controlSequence)
    output.write(position.controlSequence)
    output.write(pixel.content)
  }
}

extension TextOutputStream {
  fileprivate mutating func write(_ character: Character) {
    write(String(character))
  }
}
