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

  // MARK: - Parsing

  @Suite("Parsing")
  struct ParsingTests {

    @Test(arguments: [
      ("\u{1b}[a",      CSI(command: "a")),
      ("\u{1b}[?h",     CSI(marker: "?", command: "h")),
      ("\u{1b}[2J",     CSI(parameters: 2, command: "J")),
      ("\u{1b}[1;2H",   CSI(parameters: [1, 2], command: "H")),
      ("\u{1b}[1049m",  CSI(parameters: 1049, command: "m")),
      ("\u{1b}[;m",     CSI(parameters: [0, 0], command: "m")),
      ("\u{1b}[;1t",    CSI(parameters: [0, 1], command: "t")),
      ("\u{1b}[1;v",    CSI(parameters: [1, 0], command: "v")),
      ("\u{1b}[7;;8v",  CSI(parameters: [7, 0, 8], command: "v")),
      ("\u{1b}[ a",     CSI(intermediates: " ", command: "a")),
      ("\u{1b}[+#&$d",  CSI(intermediates: ["+", "#", "&", "$"], command: "d")),
      ("\u{1b}[?25g",   CSI(marker: "?", parameters: 25, command: "g")),
      ("\u{1b}[3 a",    CSI(parameters: 3, intermediates: " ", command: "a")),
      ("\u{1b}[?1;2#a", CSI(marker: "?", parameters: [1, 2], intermediates: "#", command: "a")),
    ])
    func parsing(input: String, expected: CSI) throws {
      #expect(try CSI(input) == expected)
    }

    @Test func `introducer: escape`() throws {
      #expect(try CSI([0x1B, 0x5B, 0x41]) == CSI(introducer: .escape, command: "A"))
    }

    @Test func `introducer: compact`() throws {
      #expect(try CSI([0x9B, 0x41]) == CSI(introducer: .compact, command: "A"))
    }

    @Test(arguments: [
      CSI(command: "a"),
      CSI(marker: "?", command: "h"),
      CSI(parameters: 2, command: "J"),
      CSI(parameters: [1, 2], command: "H"),
      CSI(parameters: 1049, command: "m"),
      CSI(marker: "?", parameters: 25, command: "h"),
      CSI(intermediates: " ", command: "a"),
      CSI(intermediates: ["#", "+"], command: "a"),
      CSI(marker: "?", parameters: [1, 2], intermediates: "#", command: "a"),
    ])
    func roundTrip(original: CSI) throws {
      #expect(try CSI(original.description) == original)
    }

    @Suite("Errors")
    struct Errors {

      @Test func empty() {
        #expect(throws: CSI.Introducer.Missing.self) {
          try CSI("")
        }
      }

      @Test func `introducer: no escape`() {
        #expect(throws: CSI.Introducer.Missing.self) {
          try CSI("\u{1b}")
        }
      }

      @Test func `introducer: invalid first`() throws {
        let error = try #require(throws: CSI.Introducer.Invalid.self) {
          try CSI("\u{1a}[")
        }
        #expect(error.description == #"Invalid CSI.Introducer: ["\#u{1a}" (0x1A)]"#)
      }

      @Test func `introducer: invalid second`() throws {
        let error = try #require(throws: CSI.Introducer.Invalid.self) {
          try CSI("\u{1b}]")
        }
        #expect(error.description == #"Invalid CSI.Introducer: ["\#u{1b}" (0x1B), "]" (0x5D)]"#)
      }

      @Test func `introducer only`() {
        #expect(throws: CSI.Command.Missing.self) {
          try CSI("\u{1b}[")
        }
      }

      @Test func `introducer + marker`() {
        #expect(throws: CSI.Command.Missing.self) {
          try CSI("\u{1b}[?")
        }
      }

      @Test func `introducer + parameter`() {
        #expect(throws: CSI.Command.Missing.self) {
          try CSI("\u{1b}[1")
        }
      }

      @Test func `introducer + parameters`() {
        #expect(throws: CSI.Command.Missing.self) {
          try CSI("\u{1b}[1;2")
        }
      }

      @Test func `parameters: colon`() throws {
        // This is currently unsupported, although it is technically valid.
        let error = try #require(throws: CSI.Command.Invalid.self) {
          try CSI("\u{1b}[4:3m")
        }
        #expect(error.description == #"Invalid CSI.Command: ":" (0x3A)"#)
      }

      @Test func `trailing bytes`() throws {
        let error = try #require(throws: CSI.TrailingBytes.self) {
          try CSI("\u{1b}[aX")

        }
        #expect(error.csi == CSI(command: "a"))
        #expect(error.remainder == [Byte(UInt8(ascii: "X"))])
      }
    }
  }
}
