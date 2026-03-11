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

  @Suite("Intermediate")
  struct IntermediateTests {

    @Test(arguments: [
      " ", "!", "\"", "#", "$", "%", "&", "'",
      "(", ")", "*", "+", ",", "-", ".", "/",
    ] as [UnicodeScalar])
    func valid(scalar: UnicodeScalar) {
      _ = CSI.Intermediate(unicodeScalarLiteral: scalar)
    }

    @Test func `invalid: <`() async {
      await #expect(processExitsWith: .failure) {
        _ = CSI.Intermediate(unicodeScalarLiteral: "<")
      }
    }

    @Test func `invalid: 0`() async {
      await #expect(processExitsWith: .failure) {
        _ = CSI.Intermediate(unicodeScalarLiteral: "0")
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
    (" "  as CSI.Intermediates, "\u{1b}[ a"),
    ("!"  as CSI.Intermediates, "\u{1b}[!a"),
    ("\"" as CSI.Intermediates, "\u{1b}[\"a"),
    ("#"  as CSI.Intermediates, "\u{1b}[#a"),
    ("$"  as CSI.Intermediates, "\u{1b}[$a"),
    ("%"  as CSI.Intermediates, "\u{1b}[%a"),
    ("&"  as CSI.Intermediates, "\u{1b}[&a"),
    ("'"  as CSI.Intermediates, "\u{1b}['a"),
    ("("  as CSI.Intermediates, "\u{1b}[(a"),
    (")"  as CSI.Intermediates, "\u{1b}[)a"),
    ("*"  as CSI.Intermediates, "\u{1b}[*a"),
    ("+"  as CSI.Intermediates, "\u{1b}[+a"),
    (","  as CSI.Intermediates, "\u{1b}[,a"),
    ("-"  as CSI.Intermediates, "\u{1b}[-a"),
    ("."  as CSI.Intermediates, "\u{1b}[.a"),
    ("/"  as CSI.Intermediates, "\u{1b}[/a"),

    (["#", "+"] as CSI.Intermediates, "\u{1b}[#+a"),
    (["+", "-"] as CSI.Intermediates, "\u{1b}[+-a"),
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
    ("=" as CSI.Marker, " "  as CSI.Intermediates, "\u{1b}[= a"),
    (">" as CSI.Marker, "!"  as CSI.Intermediates, "\u{1b}[>!a"),
    ("<" as CSI.Marker, "\"" as CSI.Intermediates, "\u{1b}[<\"a"),
    ("?" as CSI.Marker, "#"  as CSI.Intermediates, "\u{1b}[?#a"),
    ("=" as CSI.Marker, "$"  as CSI.Intermediates, "\u{1b}[=$a"),
    (">" as CSI.Marker, "%"  as CSI.Intermediates, "\u{1b}[>%a"),
    ("<" as CSI.Marker, "&"  as CSI.Intermediates, "\u{1b}[<&a"),
    ("?" as CSI.Marker, "'"  as CSI.Intermediates, "\u{1b}[?'a"),
    ("=" as CSI.Marker, "("  as CSI.Intermediates, "\u{1b}[=(a"),
    (">" as CSI.Marker, ")"  as CSI.Intermediates, "\u{1b}[>)a"),
    ("<" as CSI.Marker, "*"  as CSI.Intermediates, "\u{1b}[<*a"),
    ("?" as CSI.Marker, "+"  as CSI.Intermediates, "\u{1b}[?+a"),
    ("=" as CSI.Marker, ","  as CSI.Intermediates, "\u{1b}[=,a"),
    (">" as CSI.Marker, "-"  as CSI.Intermediates, "\u{1b}[>-a"),
    ("<" as CSI.Marker, "."  as CSI.Intermediates, "\u{1b}[<.a"),
    ("?" as CSI.Marker, "/"  as CSI.Intermediates, "\u{1b}[?/a"),

    ("=" as CSI.Marker, ["#", "+"] as CSI.Intermediates, "\u{1b}[=#+a"),
    (">" as CSI.Marker, ["+", "-"] as CSI.Intermediates, "\u{1b}[>+-a"),
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
    ("=" as CSI.Marker, 3               as CSI.Parameters, " "  as CSI.Intermediates, "\u{1b}[=3 a"),
    (">" as CSI.Marker, [3,2]           as CSI.Parameters, "!"  as CSI.Intermediates, "\u{1b}[>3;2!a"),
    ("<" as CSI.Marker, [1,2,3]         as CSI.Parameters, "\"" as CSI.Intermediates, "\u{1b}[<1;2;3\"a"),
    ("?" as CSI.Marker, [1,22,333,4444] as CSI.Parameters, "#"  as CSI.Intermediates, "\u{1b}[?1;22;333;4444#a"),
    ("=" as CSI.Marker, 3               as CSI.Parameters, "$"  as CSI.Intermediates, "\u{1b}[=3$a"),
    (">" as CSI.Marker, [3,2]           as CSI.Parameters, "%"  as CSI.Intermediates, "\u{1b}[>3;2%a"),
    ("<" as CSI.Marker, [1,2,3]         as CSI.Parameters, "&"  as CSI.Intermediates, "\u{1b}[<1;2;3&a"),
    ("?" as CSI.Marker, [1,22,333,4444] as CSI.Parameters, "'"  as CSI.Intermediates, "\u{1b}[?1;22;333;4444'a"),
    ("=" as CSI.Marker, 3               as CSI.Parameters, "("  as CSI.Intermediates, "\u{1b}[=3(a"),
    (">" as CSI.Marker, [3,2]           as CSI.Parameters, ")"  as CSI.Intermediates, "\u{1b}[>3;2)a"),
    ("<" as CSI.Marker, [1,2,3]         as CSI.Parameters, "*"  as CSI.Intermediates, "\u{1b}[<1;2;3*a"),
    ("?" as CSI.Marker, [1,22,333,4444] as CSI.Parameters, "+"  as CSI.Intermediates, "\u{1b}[?1;22;333;4444+a"),
    ("=" as CSI.Marker, 3               as CSI.Parameters, ","  as CSI.Intermediates, "\u{1b}[=3,a"),
    (">" as CSI.Marker, [3,2]           as CSI.Parameters, "-"  as CSI.Intermediates, "\u{1b}[>3;2-a"),
    ("<" as CSI.Marker, [1,2,3]         as CSI.Parameters, "."  as CSI.Intermediates, "\u{1b}[<1;2;3.a"),
    ("?" as CSI.Marker, [1,22,333,4444] as CSI.Parameters, "/"  as CSI.Intermediates, "\u{1b}[?1;22;333;4444/a"),

    ("=" as CSI.Marker, 3               as CSI.Parameters, ["#", "+"] as CSI.Intermediates, "\u{1b}[=3#+a"),
    (">" as CSI.Marker, [3,2]           as CSI.Parameters, ["+", "-"] as CSI.Intermediates, "\u{1b}[>3;2+-a"),
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
