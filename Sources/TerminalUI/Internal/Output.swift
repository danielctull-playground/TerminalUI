import Foundation

struct Output: TextOutputStream {

  private let handle: FileHandle

  mutating func write(_ string: String) {
    let data = Data(string.utf8)
    handle.write(data)
  }
}

extension Output {
  static let standard = Output(handle: .standardOutput)
}
