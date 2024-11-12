import TerminalUI
import TerminalUITesting
import Testing

@Suite("Bold", .tags(.viewModifier))
struct BoldTests {

  @Test("on")
  func on() {

    struct TestApp: App {
      var body: some View {
        Text("a").bold(true)
      }
    }

    let app = TestApp()
    let stream = TestStream()
    app.run(stream: stream)
    let controlSequences = stream.output.split(separator: "\u{1b}")
    #expect(controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39m",    // ForegroundColor default
      "[49m",    // BackgroundColor default
      "[1m",     // Bold on
      "[23m",    // Italic off
      "[24m",    // Underline off
      "[25m",    // Blinking off
      "[27m",    // Inverse off
      "[28m",    // Hidden off
      "[29m",    // Strikethrough off
      "[0;1Ha",  // Position + content
    ])
  }

  @Test("off")
  func off() {

    struct TestApp: App {
      var body: some View {
        Text("a").bold(false)
      }
    }

    let stream = TestStream()
    TestApp().run(stream: stream)
    let controlSequences = stream.output.split(separator: "\u{1b}")
    #expect(controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39m",    // ForegroundColor default
      "[49m",    // BackgroundColor default
      "[22m",    // Bold off
      "[23m",    // Italic off
      "[24m",    // Underline off
      "[25m",    // Blinking off
      "[27m",    // Inverse off
      "[28m",    // Hidden off
      "[29m",    // Strikethrough off
      "[0;1Ha",  // Position + content
    ])
  }
}
