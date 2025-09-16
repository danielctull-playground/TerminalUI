@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Offset", .tags(.modifier))
struct OffsetTests {

  private let view = Text("X")
  private let pixel = Pixel("X")

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Color.black.offset().body
    }
  }

  @Test func `x:`() {

    let canvas = TestCanvas(width: 3, height: 5)
    canvas.render {
      view.offset(x: 2)
    }

    #expect(canvas.pixels == [
      Position(x: 4, y: 3): pixel,
    ])
  }

  @Test func `y:`() {

    let canvas = TestCanvas(width: 3, height: 5)
    canvas.render {
      view.offset(y: 2)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 5): pixel,
    ])
  }

  @Test func `x:y:`() {

    let canvas = TestCanvas(width: 3, height: 5)
    canvas.render {
      view.offset(x: 1, y: 3)
    }

    #expect(canvas.pixels == [
      Position(x: 3, y: 6): pixel,
    ])
  }

  @Test func `size:`() {

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

    @Test func `default value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Text("x")
          .offset(x: 1, y: 2)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Text("x")
          .preference(key: PreferenceKey.A.self, value: "new")
          .offset(x: 1, y: 2)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
