@testable import TerminalUI
import Testing

@Suite("CSI")
struct CSITests {

  @Suite("Marker")
  struct MarkerTests {

    @Test(arguments: ["=", ">", "<", "?"] as [UnicodeScalar])
    func valid(scalar: UnicodeScalar) {
      _ = CSI.Marker(unicodeScalarLiteral: scalar)
    }

    @Test func `invalid: ;`() async {
      await #expect(processExitsWith: .failure) {
        _ = CSI.Marker(unicodeScalarLiteral: ";")
      }
    }

    @Test func `invalid: @`() async {
      await #expect(processExitsWith: .failure) {
        _ = CSI.Marker(unicodeScalarLiteral: "@")
      }
    }
  }

  @Suite("Command")
  struct CommandTests {

    @Test(arguments: [
      "@",
      "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
      "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
      "[", "\\", "]", "^", "_", "`",
      "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
      "{", "|", "}", "~"
    ] as [UnicodeScalar])
    func valid(scalar: UnicodeScalar) {
      _ = CSI.Command(unicodeScalarLiteral: scalar)
    }

    @Test func `invalid: :`() async {
      await #expect(processExitsWith: .failure) {
        _ = CSI.Command(unicodeScalarLiteral: ":")
      }
    }

    @Test func `invalid: ?`() async {
      await #expect(processExitsWith: .failure) {
        _ = CSI.Command(unicodeScalarLiteral: "?")
      }
    }

    @Test func `invalid: 1`() async {
      await #expect(processExitsWith: .failure) {
        _ = CSI.Command(unicodeScalarLiteral: "1")
      }
    }
  }

  @Test(arguments: [
    ("a" as CSI.Command, "\u{1b}[a"),
    ("A" as CSI.Command, "\u{1b}[A"),
    ("b" as CSI.Command, "\u{1b}[b"),
  ])
  func command(command: CSI.Command, expected: String) {
    var stream = MemoryTextOutputStream.memory
    stream.write(CSI(command: command))
    #expect(stream.output == expected)
  }

  @Test(arguments: [
    ("=" as CSI.Marker, "\u{1b}[=a"),
    (">" as CSI.Marker, "\u{1b}[>a"),
    ("<" as CSI.Marker, "\u{1b}[<a"),
    ("?" as CSI.Marker, "\u{1b}[?a"),
    (nil,               "\u{1b}[a"),
  ])
  func `marker + command`(marker: CSI.Marker?, expected: String) {
    var stream = MemoryTextOutputStream.memory
    stream.write(CSI(marker: marker, command: "a"))
    #expect(stream.output == expected)
  }

  @Test(arguments: [
    (3               as CSI.Parameters, "\u{1b}[3a"),
    ([3,2]           as CSI.Parameters, "\u{1b}[3;2a"),
    ([1,22,333,4444] as CSI.Parameters, "\u{1b}[1;22;333;4444a"),
  ])
  func `parameters + command`(parameters: CSI.Parameters, expected: String) {
    var stream = MemoryTextOutputStream.memory
    stream.write(CSI(parameters: parameters, command: "a"))
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
    stream.write(CSI(intermediates: intermediates, command: "a"))
    #expect(stream.output == expected)
  }

  @Test(arguments: [
    ("=" as CSI.Marker, 3               as CSI.Parameters, "\u{1b}[=3a"),
    (">" as CSI.Marker, [3,2]           as CSI.Parameters, "\u{1b}[>3;2a"),
    ("<" as CSI.Marker, [1,2,3]         as CSI.Parameters, "\u{1b}[<1;2;3a"),
    ("?" as CSI.Marker, [1,22,333,4444] as CSI.Parameters, "\u{1b}[?1;22;333;4444a"),
  ])
  func `marker + parameters + command`(
    marker: CSI.Marker,
    parameters: CSI.Parameters,
    expected: String
  ) {
    var stream = MemoryTextOutputStream.memory
    stream.write(CSI(marker: marker, parameters: parameters, command: "a"))
    #expect(stream.output == expected)
  }

  @Test(arguments: [
    ("=" as CSI.Marker, [.space] as CSI.Intermediates,            "\u{1b}[= a"),
    (">" as CSI.Marker, [.exclamation] as CSI.Intermediates,      "\u{1b}[>!a"),
    ("<" as CSI.Marker, [.quote] as CSI.Intermediates,            "\u{1b}[<\"a"),
    ("?" as CSI.Marker, [.hash] as CSI.Intermediates,             "\u{1b}[?#a"),
    ("=" as CSI.Marker, [.dollar] as CSI.Intermediates,           "\u{1b}[=$a"),
    (">" as CSI.Marker, [.percent] as CSI.Intermediates,          "\u{1b}[>%a"),
    ("<" as CSI.Marker, [.ampersand] as CSI.Intermediates,        "\u{1b}[<&a"),
    ("?" as CSI.Marker, [.apostrophe] as CSI.Intermediates,       "\u{1b}[?'a"),
    ("=" as CSI.Marker, [.leftParenthesis] as CSI.Intermediates,  "\u{1b}[=(a"),
    (">" as CSI.Marker, [.rightParenthesis] as CSI.Intermediates, "\u{1b}[>)a"),
    ("<" as CSI.Marker, [.asterisk] as CSI.Intermediates,         "\u{1b}[<*a"),
    ("?" as CSI.Marker, [.plus] as CSI.Intermediates,             "\u{1b}[?+a"),
    ("=" as CSI.Marker, [.comma] as CSI.Intermediates,            "\u{1b}[=,a"),
    (">" as CSI.Marker, [.hyphen] as CSI.Intermediates,           "\u{1b}[>-a"),
    ("<" as CSI.Marker, [.period] as CSI.Intermediates,           "\u{1b}[<.a"),
    ("?" as CSI.Marker, [.slash] as CSI.Intermediates,            "\u{1b}[?/a"),

    ("=" as CSI.Marker, [.hash, .plus] as CSI.Intermediates,      "\u{1b}[=#+a"),
    (">" as CSI.Marker, [.plus, .hyphen] as CSI.Intermediates,    "\u{1b}[>+-a"),
  ])
  func `marker + intermediates + command`(
    marker: CSI.Marker,
    intermediates: CSI.Intermediates,
    expected: String
  ) {
    var stream = MemoryTextOutputStream.memory
    stream.write(CSI(marker: marker, intermediates: intermediates, command: "a"))
    #expect(stream.output == expected)
  }

  @Test(arguments: [
    ("=" as CSI.Marker, 3               as CSI.Parameters, [.space] as CSI.Intermediates,            "\u{1b}[=3 a"),
    (">" as CSI.Marker, [3,2]           as CSI.Parameters, [.exclamation] as CSI.Intermediates,      "\u{1b}[>3;2!a"),
    ("<" as CSI.Marker, [1,2,3]         as CSI.Parameters, [.quote] as CSI.Intermediates,            "\u{1b}[<1;2;3\"a"),
    ("?" as CSI.Marker, [1,22,333,4444] as CSI.Parameters, [.hash] as CSI.Intermediates,             "\u{1b}[?1;22;333;4444#a"),
    ("=" as CSI.Marker, 3               as CSI.Parameters, [.dollar] as CSI.Intermediates,           "\u{1b}[=3$a"),
    (">" as CSI.Marker, [3,2]           as CSI.Parameters, [.percent] as CSI.Intermediates,          "\u{1b}[>3;2%a"),
    ("<" as CSI.Marker, [1,2,3]         as CSI.Parameters, [.ampersand] as CSI.Intermediates,        "\u{1b}[<1;2;3&a"),
    ("?" as CSI.Marker, [1,22,333,4444] as CSI.Parameters, [.apostrophe] as CSI.Intermediates,       "\u{1b}[?1;22;333;4444'a"),
    ("=" as CSI.Marker, 3               as CSI.Parameters, [.leftParenthesis] as CSI.Intermediates,  "\u{1b}[=3(a"),
    (">" as CSI.Marker, [3,2]           as CSI.Parameters, [.rightParenthesis] as CSI.Intermediates, "\u{1b}[>3;2)a"),
    ("<" as CSI.Marker, [1,2,3]         as CSI.Parameters, [.asterisk] as CSI.Intermediates,         "\u{1b}[<1;2;3*a"),
    ("?" as CSI.Marker, [1,22,333,4444] as CSI.Parameters, [.plus] as CSI.Intermediates,             "\u{1b}[?1;22;333;4444+a"),
    ("=" as CSI.Marker, 3               as CSI.Parameters, [.comma] as CSI.Intermediates,            "\u{1b}[=3,a"),
    (">" as CSI.Marker, [3,2]           as CSI.Parameters, [.hyphen] as CSI.Intermediates,           "\u{1b}[>3;2-a"),
    ("<" as CSI.Marker, [1,2,3]         as CSI.Parameters, [.period] as CSI.Intermediates,           "\u{1b}[<1;2;3.a"),
    ("?" as CSI.Marker, [1,22,333,4444] as CSI.Parameters, [.slash] as CSI.Intermediates,            "\u{1b}[?1;22;333;4444/a"),

    ("=" as CSI.Marker, 3               as CSI.Parameters, [.hash, .plus] as CSI.Intermediates,      "\u{1b}[=3#+a"),
    (">" as CSI.Marker, [3,2]           as CSI.Parameters, [.plus, .hyphen] as CSI.Intermediates,    "\u{1b}[>3;2+-a"),
  ])
  func `marker + parameters + intermediates + command`(
    marker: CSI.Marker,
    parameters: CSI.Parameters,
    intermediates: CSI.Intermediates,
    expected: String
  ) {
    var stream = MemoryTextOutputStream.memory
    stream.write(CSI(
      marker: marker,
      parameters: parameters,
      intermediates: intermediates,
      command: "a"
    ))
    #expect(stream.output == expected)
  }
}
