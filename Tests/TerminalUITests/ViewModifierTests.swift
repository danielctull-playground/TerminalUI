@testable import TerminalUI
import Testing

@Suite("ViewModifier", .tags(.viewModifier))
struct ViewModifierTests {

  @Test("Empty view modifier displays original contents")
  func empty() {

    struct VM<Content: View>: ViewModifier {
      func body(content: Content) -> some View {
        content
      }
    }

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("A").modifier(VM())
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39m",    // ForegroundColor default
      "[49m",    // BackgroundColor default
      "[22m",    // Bold off
      "[23m",    // Italic off
      "[24m",    // Underline off
      "[25m",    // Blinking
      "[27m",    // Inverse off
      "[28m",    // Hidden off
      "[29m",    // Strikethrough off
      "[1;1HA",  // Position + content
    ])
  }
}
