@testable import TerminalUI
import Testing

@Suite("CSI")
struct CSITests {

  @Test(arguments: [
    ("a" as CSI.Command, "\u{1b}[a"),
    ("A" as CSI.Command, "\u{1b}[A"),
    ("b" as CSI.Command, "\u{1b}[b"),
    ("1" as CSI.Command, "\u{1b}[1"),
  ])
  func command(command: CSI.Command, expected: String) {
    var stream = MemoryTextOutputStream.memory
    stream.write(CSI(command))
    #expect(stream.output == expected)
  }

  @Test(arguments: [
    (CSI.Marker.equals,       "\u{1b}[=a"),
    (CSI.Marker.greaterThan,  "\u{1b}[>a"),
    (CSI.Marker.lessThan,     "\u{1b}[<a"),
    (CSI.Marker.questionMark, "\u{1b}[?a"),
  ])
  func `marker + command`(marker: CSI.Marker, expected: String) {
    var stream = MemoryTextOutputStream.memory
    stream.write(CSI(marker, "a"))
    #expect(stream.output == expected)
  }

  @Test(arguments: [
    (3               as CSI.Parameters, "\u{1b}[3a"),
    ([3,2]           as CSI.Parameters, "\u{1b}[3;2a"),
    ([1,22,333,4444] as CSI.Parameters, "\u{1b}[1;22;333;4444a"),
  ])
  func `parameters + command`(parameters: CSI.Parameters, expected: String) {
    var stream = MemoryTextOutputStream.memory
    stream.write(CSI(parameters, "a"))
    #expect(stream.output == expected)
  }

  @Test(arguments: [
    (CSI.Marker.equals,       3               as CSI.Parameters, "\u{1b}[=3a"),
    (CSI.Marker.greaterThan,  [3,2]           as CSI.Parameters, "\u{1b}[>3;2a"),
    (CSI.Marker.lessThan,     [1,2,3]         as CSI.Parameters, "\u{1b}[<1;2;3a"),
    (CSI.Marker.questionMark, [1,22,333,4444] as CSI.Parameters, "\u{1b}[?1;22;333;4444a"),
  ])
  func `marker + parameters + command`(
    marker: CSI.Marker,
    parameters: CSI.Parameters,
    expected: String
  ) {
    var stream = MemoryTextOutputStream.memory
    stream.write(CSI(marker, parameters, "a"))
    #expect(stream.output == expected)
  }
}
