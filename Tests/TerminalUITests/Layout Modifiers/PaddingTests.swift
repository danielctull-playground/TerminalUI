@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Padding", .tags(.modifier))
struct PaddingTests {

  private let screen = TestScreen(width: 3, height: 3)
  private let view = Color.blue
  private let cell = Cell(" ", background: .blue)

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Color.black.padding(0).body
    }
  }

  @Test func `edge insets`() {

    let screen = TestScreen(width: 8, height: 6)
    screen.render {
      view.padding(EdgeInsets(top: 1, leading: 2, bottom: 3, trailing: 4))
    }

    #expect(screen.buffer.description == """
      ........
      ..▨▨....
      ..▨▨....
      ........
      ........
      ........
      """)
  }

  @Test(arguments: Array<(Edge.Set, String)>([
    (.all, """
      ...
      .▨.
      ...
      """
    ),
    (.top, """
      ...
      ▨▨▨
      ▨▨▨
      """
    ),
    (.leading, """
      .▨▨
      .▨▨
      .▨▨
      """
    ),
    (.bottom, """
      ▨▨▨
      ▨▨▨
      ...
      """
    ),
    (.trailing, """
      ▨▨.
      ▨▨.
      ▨▨.
      """
    ),
    (.horizontal, """
      .▨.
      .▨.
      .▨.
      """
    ),
    (.vertical, """
      ...
      ▨▨▨
      ...
      """
    ),
  ]))
  func `edge set`(edges: Edge.Set, expected: String) {

    screen.render {
      view.padding(edges, 1)
    }

    #expect(screen.buffer.description == expected)
  }

  @Test func `length`() async throws {

    screen.render {
      view.padding(1)
    }

    #expect(screen.buffer.description == """
      ...
      .▨.
      ...
      """)
  }

//  @Test(arguments: Array<(String, Int, Int, Int, Int)>([
//    ("12",    4,  3, 4, 3),
//    ("1234",  4,  4, 4, 4),
//    ("1234", 10, 10, 6, 3),
//  ]))
//  func size(
//    input: String,
//    proposedWidth: Int,
//    proposedHeight: Int,
//    expectedWidth: Int,
//    expectedHeight: Int
//  ) throws {
//    let proposed = ProposedViewSize(width: proposedWidth, height: proposedHeight)
//    let view = Text(input).padding(1)
//    let inputs = ViewInputs(screen: TextStreamScreen(output: .memory))
//    let items = view.makeView(inputs: inputs).displayItems
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
        Text("x")
          .padding(.all, 1)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Text("x")
          .preference(key: PreferenceKey.A.self, value: "new")
          .padding(.all, 1)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
