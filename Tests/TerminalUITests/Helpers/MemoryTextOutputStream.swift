
extension TextOutputStream where Self == MemoryTextOutputStream {
  static var memory: MemoryTextOutputStream {
    MemoryTextOutputStream()
  }
}

struct MemoryTextOutputStream: TextOutputStream {
  private var output: String = ""
  fileprivate init() {}
  mutating func write(_ string: String) {
    output.append(string)
  }
}

extension MemoryTextOutputStream {
  var controlSequences: [String] {
    output.split(separator: "\u{1b}").map(String.init)
  }
}
