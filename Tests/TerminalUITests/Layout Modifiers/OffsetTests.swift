@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Offset", .tags(.modifier))
struct OffsetTests {

  private let view = Text("X")
  private let pixel = Pixel("X")

  @Test("x:")
  func x() {

    let canvas = TestCanvas(width: 3, height: 5)
    canvas.render {
      view.offset(x: 2)
    }

    #expect(canvas.pixels == [
      Position(x: 4, y: 3): pixel,
    ])
  }

  @Test("y:")
  func y() {

    let canvas = TestCanvas(width: 3, height: 5)
    canvas.render {
      view.offset(y: 2)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 5): pixel,
    ])
  }

  @Test("x:y:")
  func xy() {

    let canvas = TestCanvas(width: 3, height: 5)
    canvas.render {
      view.offset(x: 1, y: 3)
    }

    #expect(canvas.pixels == [
      Position(x: 3, y: 6): pixel,
    ])
  }

  @Test("size:")
  func size() {

    let canvas = TestCanvas(width: 3, height: 5)
    canvas.render {
      view.offset(size: Size(width: 1, height: 3))
    }

    #expect(canvas.pixels == [
      Position(x: 3, y: 6): pixel,
    ])
  }

  @Suite("Preference Values", .tags(.preferenceValues))
  struct PreferenceValues {

    @Test("default value")
    func defaultValue() {

      var output = ""

      let renderer = Renderer(canvas: TestCanvas(width: 3, height: 3)) {
        Text("x")
          .offset(x: 1, y: 2)
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
          .offset(x: 1, y: 2)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }
      renderer.render()

      #expect(output == "new")
    }
  }
}
