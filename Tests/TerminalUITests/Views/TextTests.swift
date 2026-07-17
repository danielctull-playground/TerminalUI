@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Text", .tags(.view))
struct TextTests {

  private let screen = TestScreen(width: 5, height: 3)

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Text("").body
    }
  }

  @Test func `single line`() {

    screen.render {
      Text("Hello")
    }

    #expect(screen.buffer.description == """
      .....
      Hello
      .....
      """)
  }

  @Test func `two lines`() {

    screen.render {
      Text("Hi there")
    }

    #expect(screen.buffer.description == """
      Hi...
      there
      .....
      """)
  }

  @Test func `two lines (space is just after end)`() {

    screen.render {
      Text("Hello there")
    }

    #expect(screen.buffer.description == """
      Hello
      there
      .....
      """)
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
//    let inputs = ViewInputs(screen: TextStreamScreen(output: .memory))
//    let items = Text(input).makeView(inputs: inputs).displayItems
//    try #require(items.count == 1)
//    let size = items[0].size(for: proposed)
//    #expect(size.width == expectedWidth)
//    #expect(size.height == expectedHeight)
//  }

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Text("Hello")
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Text("Hello")
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }

  @Test func `height: zero`() {
    let screen = TestScreen(width: 3, height: 0)
    screen.render {
      Text("A")
    }
    #expect(screen.buffer.description == "")
  }

  @Test func `width: zero`() {
    let screen = TestScreen(width: 0, height: 3)
    screen.render {
      Text("A")
    }
    #expect(screen.buffer.description == "")
  }
}
