
package struct TextStreamScreen<Output: TextOutputStream> {

  @Mutable package var output: Output

  package init(output: Output) {
    self.output = output
  }
}

extension TextStreamScreen: Screen {

  package func send(_ csi: CSI) {
    output.write(csi)
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
