@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Color", .tags(.view))
struct ColorTests {

  private let screen = TestScreen(width: 3, height: 3)

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Color.black.body
    }
  }

  @Test(arguments: Color.testCases)
  func `render`(color: Color) {

    screen.render {
      color
    }

    #expect(screen.cells == [
      Position(x: 1, y: 1): Cell(" ", background: color),
      Position(x: 2, y: 1): Cell(" ", background: color),
      Position(x: 3, y: 1): Cell(" ", background: color),
      Position(x: 1, y: 2): Cell(" ", background: color),
      Position(x: 2, y: 2): Cell(" ", background: color),
      Position(x: 3, y: 2): Cell(" ", background: color),
      Position(x: 1, y: 3): Cell(" ", background: color),
      Position(x: 2, y: 3): Cell(" ", background: color),
      Position(x: 3, y: 3): Cell(" ", background: color),
    ])
  }

  @Test func `height: zero`() {
    let screen = TestScreen(width: 3, height: 0)
    screen.render {
      Color.red
    }
    #expect(screen.cells.isEmpty)
  }

  @Test func `width: zero`() {
    let screen = TestScreen(width: 0, height: 3)
    screen.render {
      Color.red
    }
    #expect(screen.cells.isEmpty)
  }

//  @Test("size", arguments: Color.testCases)
//  func size(color: Color) throws {
//    let width = Int.random(in: 0...1_000_000_000)
//    let height = Int.random(in: 0...1_000_000_000)
//    let proposed = ProposedViewSize(width: width, height: height)
//    let inputs = ViewInputs(screen: TextStreamScreen(output: .memory))
//    let items = color.makeView(inputs: inputs).displayItems
//    try #require(items.count == 1)
//    let size = items[0].size(for: proposed)
//    #expect(size.width == width)
//    #expect(size.height == height)
//  }

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test(arguments: Color.testCases)
    func `default value`(color: Color) {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        color
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }


    @Test(arguments: Color.testCases)
    func `modified value`(color: Color) {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        color
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}

extension Color {
  fileprivate static var testCases: [Color] {
    [
      .black,
      .red,
      .green,
      .yellow,
      .blue,
      .magenta,
      .cyan,
      .white,
      .default,
    ]
  }
}
