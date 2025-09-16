@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Text", .tags(.view))
struct TextTests {

  private let canvas = TestCanvas(width: 5, height: 3)

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Text("").body
    }
  }

  @Test func `single line`() {

    canvas.render {
      Text("Hello")
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 2): Pixel("H"),
      Position(x: 2, y: 2): Pixel("e"),
      Position(x: 3, y: 2): Pixel("l"),
      Position(x: 4, y: 2): Pixel("l"),
      Position(x: 5, y: 2): Pixel("o"),
    ])
  }

  @Test func `two lines`() {

    canvas.render {
      Text("Hi there")
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("H"),
      Position(x: 2, y: 1): Pixel("i"),
      Position(x: 1, y: 2): Pixel("t"),
      Position(x: 2, y: 2): Pixel("h"),
      Position(x: 3, y: 2): Pixel("e"),
      Position(x: 4, y: 2): Pixel("r"),
      Position(x: 5, y: 2): Pixel("e"),
    ])
  }

  @Test func `two lines (space is just after end)`() {

    canvas.render {
      Text("Hello there")
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("H"),
      Position(x: 2, y: 1): Pixel("e"),
      Position(x: 3, y: 1): Pixel("l"),
      Position(x: 4, y: 1): Pixel("l"),
      Position(x: 5, y: 1): Pixel("o"),
      Position(x: 1, y: 2): Pixel("t"),
      Position(x: 2, y: 2): Pixel("h"),
      Position(x: 3, y: 2): Pixel("e"),
      Position(x: 4, y: 2): Pixel("r"),
      Position(x: 5, y: 2): Pixel("e"),
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
//    let inputs = ViewInputs(canvas: TextStreamCanvas(output: .memory))
//    let items = Text(input).makeView(inputs: inputs).displayItems
//    try #require(items.count == 1)
//    let size = items[0].size(for: proposed)
//    #expect(size.width == expectedWidth)
//    #expect(size.height == expectedHeight)
//  }

  @Suite("Preference Values", .tags(.preferenceValues))
  struct PreferenceValues {

    @Test func `default value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Text("Hello")
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Text("Hello")
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }

  @Test func `height: zero`() {
    let canvas = TestCanvas(width: 3, height: 0)
    canvas.render {
      Text("A")
    }
    #expect(canvas.pixels.isEmpty)
  }

  @Test func `width: zero`() {
    let canvas = TestCanvas(width: 0, height: 3)
    canvas.render {
      Text("A")
    }
    #expect(canvas.pixels.isEmpty)
  }
}
