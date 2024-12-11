
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
}

extension TextOutputStream {
  fileprivate mutating func write(_ character: Character) {
    write(String(character))
  }
}
