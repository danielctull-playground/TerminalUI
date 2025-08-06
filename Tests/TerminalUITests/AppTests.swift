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

    Rect.window = Rect(x: 1, y: 1, width: 1, height: 1)
    let canvas = TextStreamCanvas(output: .memory)
    TestApp.run(canvas: canvas)

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39;49;22;23;24;25;27;28;29m",
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

    Rect.window = Rect(x: 1, y: 1, width: 1, height: 1)
    let canvas = TextStreamCanvas(output: .memory)
    TestApp.run(canvas: canvas)

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39;49;1;23;24;25;27;28;29m",
      "[1;1Ha",  // Position + content
    ])
  }
}
