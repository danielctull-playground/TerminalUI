
final class TestStream: TextOutputStream {
  var output: String = ""
  func write(_ string: String) {
    output.append(string)
  }
}
