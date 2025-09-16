@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("ForegroundColor", .tags(.modifier))
struct ForegroundColorTests {

  @Test(arguments: [
    (Color.`default`, "39"),
    (Color.black, "30"),
    (Color.red, "31"),
    (Color.green, "32"),
    (Color.yellow, "33"),
    (Color.blue, "34"),
    (Color.magenta, "35"),
    (Color.cyan, "36"),
    (Color.white, "37"),

    (Color(white: 0), "38;2;0;0;0"),
    (Color(white: 1), "38;2;255;255;255"),
    (Color(white: 0.4), "38;2;102;102;102"),
    (Color(white: -1), "38;2;0;0;0"), // Clamped
    (Color(white: 2), "38;2;255;255;255"), // Clamped

    (Color(red: 0, green: 0, blue: 0), "38;2;0;0;0"),
    (Color(red: 1, green: 1, blue: 1), "38;2;255;255;255"),
    (Color(red: 1.0, green: 0.5, blue: 0), "38;2;255;127;0"),
    (Color(red: 0.8, green: 0.9, blue: 0.4), "38;2;204;229;102"),
    (Color(red: 0.2, green: 0.3, blue: 0.7), "38;2;51;76;178"),
    (Color(red: -21, green: -0.1, blue: -2), "38;2;0;0;0"), // Clamped
    (Color(red: 10, green: 1.1, blue: 2.1), "38;2;255;255;255"), // Clamped
  ])
  func `Text Output`(foregroundColor: Color, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").foregroundColor(foregroundColor)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[\(expected);49;22;23;24;25;27;28;29m",
      "[1;1Ha",  // Position + content
    ])
  }
}
