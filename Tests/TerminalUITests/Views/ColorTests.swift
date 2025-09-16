@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Color", .tags(.view))
struct ColorTests {

  private let canvas = TestCanvas(width: 3, height: 3)

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Color.black.body
    }
  }

  @Test("render", arguments: Color.testCases)
  func render(color: Color) {

    canvas.render {
      color
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel(" ", background: color),
      Position(x: 2, y: 1): Pixel(" ", background: color),
      Position(x: 3, y: 1): Pixel(" ", background: color),
      Position(x: 1, y: 2): Pixel(" ", background: color),
      Position(x: 2, y: 2): Pixel(" ", background: color),
      Position(x: 3, y: 2): Pixel(" ", background: color),
      Position(x: 1, y: 3): Pixel(" ", background: color),
      Position(x: 2, y: 3): Pixel(" ", background: color),
      Position(x: 3, y: 3): Pixel(" ", background: color),
    ])
  }

  @Test func `height: zero`() {
    let canvas = TestCanvas(width: 3, height: 0)
    canvas.render {
      Color.red
    }
    #expect(canvas.pixels.isEmpty)
  }

  @Test func `width: zero`() {
    let canvas = TestCanvas(width: 0, height: 3)
    canvas.render {
      Color.red
    }
    #expect(canvas.pixels.isEmpty)
  }

//  @Test("size", arguments: Color.testCases)
//  func size(color: Color) throws {
//    let width = Int.random(in: 0...1_000_000_000)
//    let height = Int.random(in: 0...1_000_000_000)
//    let proposed = ProposedViewSize(width: width, height: height)
//    let inputs = ViewInputs(canvas: TextStreamCanvas(output: .memory))
//    let items = color.makeView(inputs: inputs).displayItems
//    try #require(items.count == 1)
//    let size = items[0].size(for: proposed)
//    #expect(size.width == width)
//    #expect(size.height == height)
//  }

  @Suite("Preference Values", .tags(.preferenceValues))
  struct PreferenceValues {

    @Test("default value", arguments: Color.testCases)
    func defaultValue(color: Color) {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        color
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }


    @Test("modified value", arguments: Color.testCases)
    func modifiedValue(color: Color) {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
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
