@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Screen")
struct ScreenTests {

  @Test func `Drawing with default values`() {
    let screen = TextOutputScreen(output: .memory)
    screen.draw([Position(x: 2, y: 1): Cell("a")])
    #expect(screen.output.controlSequences == [
      "[39;49;22;23;24;25;27;28;29m",
      "[1;2Ha", // Position + content
    ])
  }

  @Test func `Center alignment`() {
    let screen = TestScreen(width: 3, height: 3)
    screen.render {
      Text("A")
    }

    #expect(screen.buffer.description == """
      ___
      _A_
      ___
      """)
  }

  @Suite("Buffer")
  struct ScreenBufferTests {

    @Test func description() async throws {

      let buffer: ScreenBuffer = [
        Position(x: 2, y: 1): Cell(content: "A", style: .default),
        Position(x: 3, y: 1): Cell(content: "B", style: .default),
        Position(x: 4, y: 1): Cell(content: "C", style: .default),
        Position(x: 5, y: 1): Cell(content: "D", style: .default),

        Position(x: 1, y: 2): Cell(content: " ", style: Style(backgroundColor: .red)),
        Position(x: 2, y: 2): Cell(content: " ", style: Style(backgroundColor: .blue)),
        Position(x: 3, y: 2): Cell(content: " ", style: Style(backgroundColor: .green)),
        Position(x: 4, y: 2): Cell(content: " ", style: Style(backgroundColor: .yellow)),
        Position(x: 5, y: 2): Cell(content: " ", style: Style(backgroundColor: .black)),
        Position(x: 6, y: 2): Cell(content: " ", style: Style(backgroundColor: .white)),

        Position(x: 1, y: 3): Cell(content: " ", style: Style(foregroundColor: .red)),
        Position(x: 2, y: 3): Cell(content: " ", style: Style(bold: .on)),
        Position(x: 3, y: 3): Cell(content: " ", style: Style(italic: .on)),
        Position(x: 4, y: 3): Cell(content: " ", style: Style(underline: .single)),
        Position(x: 5, y: 3): Cell(content: " ", style: Style(underline: .double)),
        Position(x: 6, y: 3): Cell(content: " ", style: Style(blinking: .on)),

        Position(x: 2, y: 4): Cell(content: "E", style: .default),
        Position(x: 3, y: 4): Cell(content: " ", style: .default),
        Position(x: 4, y: 4): Cell(content: " ", style: .default),
        Position(x: 5, y: 4): Cell(content: "F", style: .default),
      ]

      #expect(buffer.description == """
        _ABCD_
        ▧▨▤▥▩▢
        ??????
        _E__F_
        """)
    }
  }
}
