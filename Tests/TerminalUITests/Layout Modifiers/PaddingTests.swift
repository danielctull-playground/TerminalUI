@testable import TerminalUI
import TerminalUITesting
import Testing

@MainActor
@Suite("Padding", .tags(.modifier))
struct PaddingTests {

  private let canvas = TestCanvas(width: 3, height: 3)
  private let view = Color.blue
  private let pixel = Pixel(" ", background: .blue)

  @Test("edge insets")
  func edgeInsets() {

    let canvas = TestCanvas(width: 8, height: 6)
    canvas.render {
      view.padding(EdgeInsets(top: 1, leading: 2, bottom: 3, trailing: 4))
    }

    #expect(canvas.pixels == [
      Position(x: 3, y: 2): pixel,
      Position(x: 4, y: 2): pixel,
      Position(x: 3, y: 3): pixel,
      Position(x: 4, y: 3): pixel,
    ])
  }

  @Test("all")
  func all() async throws {

    canvas.render {
      view.padding(.all, 1)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 2): pixel,
    ])
  }

  @Test("top")
  func top() async throws {

    canvas.render {
      view.padding(.top, 1)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
      Position(x: 1, y: 3): pixel,
      Position(x: 2, y: 3): pixel,
      Position(x: 3, y: 3): pixel,
    ])
  }

  @Test("leading")
  func leading() async throws {

    canvas.render {
      view.padding(.leading, 1)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 1): pixel,
      Position(x: 3, y: 1): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
      Position(x: 2, y: 3): pixel,
      Position(x: 3, y: 3): pixel,
    ])
  }

  @Test("bottom")
  func bottom() async throws {

    canvas.render {
      view.padding(.bottom, 1)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): pixel,
      Position(x: 2, y: 1): pixel,
      Position(x: 3, y: 1): pixel,
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
    ])
  }

  @Test("trailing")
  func trailing() async throws {

    canvas.render {
      view.padding(.trailing, 1)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): pixel,
      Position(x: 2, y: 1): pixel,
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 1, y: 3): pixel,
      Position(x: 2, y: 3): pixel,
    ])
  }

  @Test("horizontal")
  func horizontal() async throws {

    canvas.render {
      view.padding(.horizontal, 1)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 1): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 2, y: 3): pixel,
    ])
  }

  @Test("vertical")
  func vertical() async throws {

    canvas.render {
      view.padding(.vertical, 1)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
    ])
  }

  @Test("length")
  func length() async throws {

    canvas.render {
      view.padding(1)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 2): pixel,
    ])
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
//    let inputs = ViewInputs(canvas: TextStreamCanvas(output: .memory))
//    let items = view.makeView(inputs: inputs).displayItems
//    try #require(items.count == 1)
//    let size = items[0].size(for: proposed)
//    #expect(size.width == expectedWidth)
//    #expect(size.height == expectedHeight)
//  }

  @MainActor
  @Suite("Preference Values", .tags(.preferenceValues))
  struct PreferenceValues {

    @Test("default value")
    func defaultValue() {

      var output = ""

      let renderer = Renderer(canvas: TestCanvas(width: 3, height: 3)) {
        Text("x")
          .padding(.all, 1)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }
      renderer.render()

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test("modified value")
    func modifiedValue() {

      var output = ""

      let renderer = Renderer(canvas: TestCanvas(width: 3, height: 3)) {
        Text("x")
          .preference(key: PreferenceKey.A.self, value: "new")
          .padding(.all, 1)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }
      renderer.render()

      #expect(output == "new")
    }
  }
}
