import Foundation

extension TextOutputStream where Self == FileHandleTextOutputStream {
  static func fileHandle(
    _ fileHandle: FileHandle
  ) -> FileHandleTextOutputStream {
    FileHandleTextOutputStream(fileHandle: fileHandle)
  }
}

public struct FileHandleTextOutputStream: TextOutputStream {
  fileprivate let fileHandle: FileHandle
  public mutating func write(_ string: String) {
    fileHandle.write(Data(string.utf8))
  }
}
