@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("ViewModifier", .tags(.modifier))
struct ViewModifierTests {

  private struct VM<Content: View>: ViewModifier {
    func body(content: Content) -> some View {
      content
    }
  }

  @Test func `Empty view modifier displays original contents`() {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("A").modifier(VM())
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39;49;22;23;24;25;27;28;29m",
      "[1;1HA",  // Position + content
    ])
  }

  @Test(.tags(.state))
  func `sibling modifier state is independent`() {

    struct Replace<Content: View>: ViewModifier {
      let value: String
      @State private var shown = "?"
      func body(content: Content) -> some View {
        Text(shown)
          .preference(key: PreferenceKey.A.self, value: value)
          .onPreferenceChange(PreferenceKey.A.self) { shown = $0 }
      }
    }

    let canvas = TestCanvas(width: 1, height: 2)
    canvas.render {
      VStack(spacing: 0) {
        Color.black.modifier(Replace(value: "a"))
        Color.black.modifier(Replace(value: "b"))
      }
    }

    #expect(canvas.cells == [
      Position(x: 1, y: 1): Cell("a"),
      Position(x: 1, y: 2): Cell("b"),
    ])
  }

//  @Test(arguments: Array<(String, Int, Int, Int, Int)>([
//    ("12345", 5, 1, 5, 1),
//    ("12345", 3, 2, 3, 2),
//    ("123 456 789", 5, 4, 3, 3),
//    ("123456789", 5, 5, 5, 2),
//    ("123456", 5, 5, 5, 2),
//  ]))
//  func size(
//    input: String,
//    proposedWidth: Int,
//    proposedHeight: Int,
//    expectedWidth: Int,
//    expectedHeight: Int
//  ) throws {
//    let proposed = ProposedViewSize(width: proposedWidth, height: proposedHeight)
//    let view = Text(input).modifier(VM())
//    let inputs = ViewInputs(canvas: TextStreamCanvas(output: .memory))
//    let items = view.makeView(inputs: inputs).displayItems
//    try #require(items.count == 1)
//    let size = items[0].size(for: proposed)
//    #expect(size.width == expectedWidth)
//    #expect(size.height == expectedHeight)
//  }
}
