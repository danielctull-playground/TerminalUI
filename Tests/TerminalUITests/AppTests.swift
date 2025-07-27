@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("App")
struct AppTests {

  @Test("Drawing with default values")
  func defaultValues() {

    struct TestApp: App {
      var body: some View {
        Text("a")
      }
    }

    let app = TestApp()
    let canvas = TextStreamCanvas(output: .memory)
    canvas.render(size: Size(width: 1, height: 1)) {
      app.body
    }
    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[22;23;24;25;27;28;29;39;49m",
      "[1;1Ha",  // Position + content
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
    let canvas = TextStreamCanvas(output: .memory)
    canvas.render(size: Size(width: 1, height: 1)) {
      app.body
    }
    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[1;23;24;25;27;28;29;39;49m",
      "[1;1Ha",  // Position + content
    ])
  }
}
