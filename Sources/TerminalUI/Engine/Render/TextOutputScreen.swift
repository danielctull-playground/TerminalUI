import Foundation

package struct TextOutputScreen<Output: TextOutputStream> {

  @Mutable package var output: Output

  package init(output: Output) {
    self.output = output
  }
}

extension TextOutputScreen: Screen {

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

// MARK: - FileHandle Support

extension TextOutputStream where Self == FileHandleTextOutputStream {
  static func fileHandle(
    _ fileHandle: FileHandle
  ) -> FileHandleTextOutputStream {
    FileHandleTextOutputStream(fileHandle: fileHandle)
  }
}

struct FileHandleTextOutputStream: TextOutputStream {
  fileprivate let fileHandle: FileHandle
  mutating func write(_ string: String) {
    fileHandle.write(Data(string.utf8))
  }
}
