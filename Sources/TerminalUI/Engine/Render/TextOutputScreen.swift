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

    // Building a string here and flushing it to the screen at once removes
    // stuttering over many cells. This way the changes should all appear at
    // once.

    var result = ""

    for (position, cell) in buffer.cells {
      result.append(String(.selectGraphicRendition(cell.style.graphicRendition)))
      result.append(String(position.csi))
      result.append(cell.content)
    }

    output.write(result)
  }
}

// MARK: - TextOutputStream

extension TextOutputStream {

  fileprivate mutating func write(_ csi: CSI) {
    write(String(csi))
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
