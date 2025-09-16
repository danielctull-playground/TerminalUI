import Foundation
@testable import TerminalUI
import Testing

@Suite("FileHandleTextOutputStream")
struct FileHandleTextOutputStreamTests {

  @Test func `Stream output is correct`() throws {
    try FileManager().withTemporaryDirectory { directory in
      let url = directory.appending(path: "file")
      try Data().write(to: url)
      let fileHandle = try FileHandle(forWritingTo: url)
      var stream: TextOutputStream = .fileHandle(fileHandle)
      let input = UUID().uuidString
      stream.write(input)
      #expect(try String(contentsOf: url, encoding: .utf8) == input)
    }
  }
}

extension FileManager {

  fileprivate func withTemporaryDirectory(
    _ perform: (URL) throws -> Void
  ) throws {
    let url = temporaryDirectory.appendingPathComponent(UUID().uuidString)
    defer { try? removeItem(at: url) }
    try createDirectory(at: url, withIntermediateDirectories: true)
    try perform(url)
  }
}
