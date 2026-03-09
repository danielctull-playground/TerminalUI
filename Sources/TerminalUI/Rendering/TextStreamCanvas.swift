
package struct TextStreamCanvas<Output: TextOutputStream>: Canvas {
  @Mutable package var output: Output

  package init(output: Output) {
    self.output = output
    self.output.write(.clearScreen)
    self.output.write(.alternativeBuffer(.on))
    self.output.write(.cursorVisibility(.off))
  }

  package func beginUpdates() {
    output.write(CSI(.questionMark, 2026, "h"))
  }

  package func endUpdates() {
    output.write(CSI(.questionMark, 2026, "l"))
  }

  package func draw(_ pixel: Pixel, at position: Position) {
    output.write(.selectGraphicRendition(pixel.graphicRendition))
    output.write(position.csi)
    output.write(pixel.content)
  }
}

extension TextOutputStream {
  fileprivate mutating func write(_ character: Character) {
    write(String(character))
  }
}
