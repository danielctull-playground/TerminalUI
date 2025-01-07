@testable import TerminalUI
import Testing

@Suite("ViewModifier", .tags(.viewModifier))
struct ViewModifierTests {

  private struct VM<Content: View>: ViewModifier {
    func body(content: Content) -> some View {
      content
    }
  }

  @Test("Empty view modifier displays original contents")
  func empty() {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: ProposedSize(width: 1, height: 1)) {
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

  @Test(arguments: Array<(String, Int, Int, Int, Int)>([
    ("12345", 5, 1, 5, 1),
    ("12345", 3, 2, 3, 2),
    ("123 456 789", 5, 4, 3, 3),
    ("123456789", 5, 5, 5, 2),
    ("123456", 5, 5, 5, 2),
  ]))
  func size(
    input: String,
    proposedWidth: Int,
    proposedHeight: Int,
    expectedWidth: Int,
    expectedHeight: Int
  ) {
    let proposed = ProposedSize(width: proposedWidth, height: proposedHeight)
    let view = Text(input).modifier(VM())
    let size = view._size(for: proposed)
    #expect(size.width == expectedWidth)
    #expect(size.height == expectedHeight)
  }
}
