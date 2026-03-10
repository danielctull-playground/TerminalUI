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
    ([.space] as CSI.Intermediates,            "\u{1b}[ a"),
    ([.exclamation] as CSI.Intermediates,      "\u{1b}[!a"),
    ([.quote] as CSI.Intermediates,            "\u{1b}[\"a"),
    ([.hash] as CSI.Intermediates,             "\u{1b}[#a"),
    ([.dollar] as CSI.Intermediates,           "\u{1b}[$a"),
    ([.percent] as CSI.Intermediates,          "\u{1b}[%a"),
    ([.ampersand] as CSI.Intermediates,        "\u{1b}[&a"),
    ([.apostrophe] as CSI.Intermediates,       "\u{1b}['a"),
    ([.leftParenthesis] as CSI.Intermediates,  "\u{1b}[(a"),
    ([.rightParenthesis] as CSI.Intermediates, "\u{1b}[)a"),
    ([.asterisk] as CSI.Intermediates,         "\u{1b}[*a"),
    ([.plus] as CSI.Intermediates,             "\u{1b}[+a"),
    ([.comma] as CSI.Intermediates,            "\u{1b}[,a"),
    ([.hyphen] as CSI.Intermediates,           "\u{1b}[-a"),
    ([.period] as CSI.Intermediates,           "\u{1b}[.a"),
    ([.slash] as CSI.Intermediates,            "\u{1b}[/a"),

    ([.hash, .plus] as CSI.Intermediates,      "\u{1b}[#+a"),
    ([.plus, .hyphen] as CSI.Intermediates,    "\u{1b}[+-a"),
  ])
  func `intermediates + command`(
    intermediates: CSI.Intermediates,
    expected: String
  ) {
    var stream = MemoryTextOutputStream.memory
    stream.write(CSI(intermediates, "a"))
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

  @Test(arguments: [
    (CSI.Marker.equals,       [.space] as CSI.Intermediates,            "\u{1b}[= a"),
    (CSI.Marker.greaterThan,  [.exclamation] as CSI.Intermediates,      "\u{1b}[>!a"),
    (CSI.Marker.lessThan,     [.quote] as CSI.Intermediates,            "\u{1b}[<\"a"),
    (CSI.Marker.questionMark, [.hash] as CSI.Intermediates,             "\u{1b}[?#a"),
    (CSI.Marker.equals,       [.dollar] as CSI.Intermediates,           "\u{1b}[=$a"),
    (CSI.Marker.greaterThan,  [.percent] as CSI.Intermediates,          "\u{1b}[>%a"),
    (CSI.Marker.lessThan,     [.ampersand] as CSI.Intermediates,        "\u{1b}[<&a"),
    (CSI.Marker.questionMark, [.apostrophe] as CSI.Intermediates,       "\u{1b}[?'a"),
    (CSI.Marker.equals,       [.leftParenthesis] as CSI.Intermediates,  "\u{1b}[=(a"),
    (CSI.Marker.greaterThan,  [.rightParenthesis] as CSI.Intermediates, "\u{1b}[>)a"),
    (CSI.Marker.lessThan,     [.asterisk] as CSI.Intermediates,         "\u{1b}[<*a"),
    (CSI.Marker.questionMark, [.plus] as CSI.Intermediates,             "\u{1b}[?+a"),
    (CSI.Marker.equals,       [.comma] as CSI.Intermediates,            "\u{1b}[=,a"),
    (CSI.Marker.greaterThan,  [.hyphen] as CSI.Intermediates,           "\u{1b}[>-a"),
    (CSI.Marker.lessThan,     [.period] as CSI.Intermediates,           "\u{1b}[<.a"),
    (CSI.Marker.questionMark, [.slash] as CSI.Intermediates,            "\u{1b}[?/a"),

    (CSI.Marker.equals,       [.hash, .plus] as CSI.Intermediates,      "\u{1b}[=#+a"),
    (CSI.Marker.greaterThan,  [.plus, .hyphen] as CSI.Intermediates,    "\u{1b}[>+-a"),
  ])
  func `marker + intermediates + command`(
    marker: CSI.Marker,
    intermediates: CSI.Intermediates,
    expected: String
  ) {
    var stream = MemoryTextOutputStream.memory
    stream.write(CSI(marker, intermediates, "a"))
    #expect(stream.output == expected)
  }

  @Test(arguments: [
    (CSI.Marker.equals,       3               as CSI.Parameters, [.space] as CSI.Intermediates,            "\u{1b}[=3 a"),
    (CSI.Marker.greaterThan,  [3,2]           as CSI.Parameters, [.exclamation] as CSI.Intermediates,      "\u{1b}[>3;2!a"),
    (CSI.Marker.lessThan,     [1,2,3]         as CSI.Parameters, [.quote] as CSI.Intermediates,            "\u{1b}[<1;2;3\"a"),
    (CSI.Marker.questionMark, [1,22,333,4444] as CSI.Parameters, [.hash] as CSI.Intermediates,             "\u{1b}[?1;22;333;4444#a"),
    (CSI.Marker.equals,       3               as CSI.Parameters, [.dollar] as CSI.Intermediates,           "\u{1b}[=3$a"),
    (CSI.Marker.greaterThan,  [3,2]           as CSI.Parameters, [.percent] as CSI.Intermediates,          "\u{1b}[>3;2%a"),
    (CSI.Marker.lessThan,     [1,2,3]         as CSI.Parameters, [.ampersand] as CSI.Intermediates,        "\u{1b}[<1;2;3&a"),
    (CSI.Marker.questionMark, [1,22,333,4444] as CSI.Parameters, [.apostrophe] as CSI.Intermediates,       "\u{1b}[?1;22;333;4444'a"),
    (CSI.Marker.equals,       3               as CSI.Parameters, [.leftParenthesis] as CSI.Intermediates,  "\u{1b}[=3(a"),
    (CSI.Marker.greaterThan,  [3,2]           as CSI.Parameters, [.rightParenthesis] as CSI.Intermediates, "\u{1b}[>3;2)a"),
    (CSI.Marker.lessThan,     [1,2,3]         as CSI.Parameters, [.asterisk] as CSI.Intermediates,         "\u{1b}[<1;2;3*a"),
    (CSI.Marker.questionMark, [1,22,333,4444] as CSI.Parameters, [.plus] as CSI.Intermediates,             "\u{1b}[?1;22;333;4444+a"),
    (CSI.Marker.equals,       3               as CSI.Parameters, [.comma] as CSI.Intermediates,            "\u{1b}[=3,a"),
    (CSI.Marker.greaterThan,  [3,2]           as CSI.Parameters, [.hyphen] as CSI.Intermediates,           "\u{1b}[>3;2-a"),
    (CSI.Marker.lessThan,     [1,2,3]         as CSI.Parameters, [.period] as CSI.Intermediates,           "\u{1b}[<1;2;3.a"),
    (CSI.Marker.questionMark, [1,22,333,4444] as CSI.Parameters, [.slash] as CSI.Intermediates,            "\u{1b}[?1;22;333;4444/a"),

    (CSI.Marker.equals,       3               as CSI.Parameters, [.hash, .plus] as CSI.Intermediates,      "\u{1b}[=3#+a"),
    (CSI.Marker.greaterThan,  [3,2]           as CSI.Parameters, [.plus, .hyphen] as CSI.Intermediates,    "\u{1b}[>3;2+-a"),
  ])
  func `marker + parameters + intermediates + command`(
    marker: CSI.Marker,
    parameters: CSI.Parameters,
    intermediates: CSI.Intermediates,
    expected: String
  ) {
    var stream = MemoryTextOutputStream.memory
    stream.write(CSI(marker, parameters, intermediates, "a"))
    #expect(stream.output == expected)
  }
}
