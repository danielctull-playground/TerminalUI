
package struct TextStreamCanvas<Output: TextOutputStream>: Canvas {
  @Mutable package var output: Output

  package init(output: Output) {
    self.output = output
    self.output.write(.clearScreen)
    self.output.write(.alternativeBuffer(.on))
    self.output.write(.cursorVisibility(.off))
  }

  package func draw(_ cells: [Position: Cell]) {
    for (position, cell) in cells {
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
