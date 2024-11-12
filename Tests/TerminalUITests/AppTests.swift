
@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("App Tests")
struct AppTests {

  @Test("Drawing with default values")
  func defaultValues() {

    struct TestApp: App {
      var body: some View {
        Text("a")
      }
    }

    let app = TestApp()
    let stream = TestStream()
    app.run(stream: stream)
    let controls = stream.output.split(separator: "\u{1b}")
    #expect(controls == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[0;1H",   // Position
      "[39m",    // ForegroundColor
      "[49m",    // BackgroundColor
      "[22m",    // Bold
      "[23m",    // Italic
      "[24m",    // Underline
      "[25m",    // Blinking
      "[27m",    // Inverse
      "[28m",    // Hidden
      "[29ma",   // Strikethrough & content
    ])
  }

  @Test("Bold")
  func bold() {

    struct TestApp: App {
      var body: some View {
        Text("a")
          .bold()
      }
    }

    let app = TestApp()
    let stream = TestStream()
    app.run(stream: stream)
    let controls = stream.output.split(separator: "\u{1b}")
    #expect(controls == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[0;1H",   // Position
      "[39m",    // ForegroundColor
      "[49m",    // BackgroundColor
      "[1m",     // Bold on
      "[23m",    // Italic off
      "[24m",    // Underline off
      "[25m",    // Blinking off
      "[27m",    // Inverse off
      "[28m",    // Hidden off
      "[29ma",   // Strikethrough off & content
    ])
  }
}
