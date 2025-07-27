
struct TextStreamCanvas<Output: TextOutputStream>: Canvas {
  @Mutable var output: Output

  init(output: Output) {
    self.output = output
    self.output.write(ControlSequence.clearScreen)
    self.output.write(AlternativeBuffer.on.control)
    self.output.write(CursorVisibility.off.control)
  }

  func draw(_ pixel: Pixel, at position: Position) {
    output.write(.selectGraphicRendition(pixel.foreground.foreground))
    output.write(.selectGraphicRendition(pixel.background.background))
    output.write(.selectGraphicRendition(pixel.bold.graphicRendition))
    output.write(.selectGraphicRendition(pixel.italic.graphicRendition))
    output.write(.selectGraphicRendition(pixel.underline.graphicRendition))
    output.write(.selectGraphicRendition(pixel.blinking.graphicRendition))
    output.write(.selectGraphicRendition(pixel.inverse.graphicRendition))
    output.write(.selectGraphicRendition(pixel.hidden.graphicRendition))
    output.write(.selectGraphicRendition(pixel.strikethrough.graphicRendition))
    output.write(position.controlSequence)
    output.write(pixel.content)
  }
}

extension TextOutputStream {
  fileprivate mutating func write(_ character: Character) {
    write(String(character))
  }
}
