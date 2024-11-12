
final class TestStream: TextOutputStream {
  var output: String = ""
  func write(_ string: String) {
    output.append(string)
  }
}

extension TestStream {
  var controlSequences: [String] {
    output.split(separator: "\u{1b}").map(String.init)
  }
}
