
package struct TextStreamScreen<Output: TextOutputStream>: Screen {
  @Mutable package var output: Output

  package init(output: Output) {
    self.output = output
    self.output.write(.clearScreen)
    self.output.write(.alternativeBuffer(.on))
    self.output.write(.cursorVisibility(.off))
  }

  package func draw(_ buffer: Buffer) {
    for (position, cell) in buffer.cells {
      output.write(.selectGraphicRendition(cell.style.graphicRendition))
      output.write(position.csi)
      output.write(cell.content)
    }
  }
}

extension TextOutputStream {
  fileprivate mutating func write(_ character: Character) {
    write(String(character))
  }
}
