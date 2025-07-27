
struct TextStreamCanvas<Output: TextOutputStream>: Canvas {
  @Mutable var output: Output

  init(output: Output) {
    self.output = output
    self.output.write(ControlSequence.clearScreen)
    self.output.write(AlternativeBuffer.on.control)
    self.output.write(CursorVisibility.off.control)
  }

  func draw(_ pixel: Pixel, at position: Position) {
    output.write(.selectGraphicRendition(pixel.graphicRendition))
    output.write(position.controlSequence)
    output.write(pixel.content)
  }
}

extension TextOutputStream {
  fileprivate mutating func write(_ character: Character) {
    write(String(character))
  }
}
