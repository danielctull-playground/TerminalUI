@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("FixedSize", .tags(.modifier))
struct FixedSizeTests {

  private let view = Color.blue
  private let pixel = Pixel(" ", background: .blue)

  @Test("horizontal")
  func horizontal() {

    let canvas = TestCanvas(width: 1, height: 1)
    canvas.render {
      view.fixedSize(horizontal: true, vertical: false)
    }

    // The default length for a nil length in a proposed size is 10.
    #expect(canvas.pixels == [
      Position(x: -4, y: 1): pixel,
      Position(x: -3, y: 1): pixel,
      Position(x: -2, y: 1): pixel,
      Position(x: -1, y: 1): pixel,
      Position(x:  0, y: 1): pixel,
      Position(x:  1, y: 1): pixel,
      Position(x:  2, y: 1): pixel,
      Position(x:  3, y: 1): pixel,
      Position(x:  4, y: 1): pixel,
      Position(x:  5, y: 1): pixel,
    ])
  }

  @Test("vertical")
  func vertical() {

    let canvas = TestCanvas(width: 1, height: 1)
    canvas.render {
      view.fixedSize(horizontal: false, vertical: true)
    }

    // The default length for a nil length in a proposed size is 10.
    #expect(canvas.pixels == [
      Position(x: 1, y: -4): pixel,
      Position(x: 1, y: -3): pixel,
      Position(x: 1, y: -2): pixel,
      Position(x: 1, y: -1): pixel,
      Position(x: 1, y:  0): pixel,
      Position(x: 1, y:  1): pixel,
      Position(x: 1, y:  2): pixel,
      Position(x: 1, y:  3): pixel,
      Position(x: 1, y:  4): pixel,
      Position(x: 1, y:  5): pixel,
    ])
  }

  @Test("both")
  func both() {

    let canvas = TestCanvas(width: 1, height: 1)
    canvas.render {
      view.fixedSize(horizontal: true, vertical: true)
    }

    // The default length for a nil length in a proposed size is 10.
    #expect(canvas.pixels.count == 100)

    let xs = -4...5
    let ys = -4...5
    let positions = xs.flatMap { x in
      ys.map { y in
        Position(x: x, y: y)
      }
    }

    let expected = Dictionary(uniqueKeysWithValues: positions.map { ($0, pixel) })
    #expect(canvas.pixels == expected)
  }

  @MainActor
  @Suite("Preference Values", .tags(.preferenceValues))
  struct PreferenceValues {

    @Test("default value")
    func defaultValue() {

      var output = ""

      let renderer = Renderer(canvas: TestCanvas(width: 3, height: 3)) {
        Text("x")
          .fixedSize(horizontal: true, vertical: false)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }
      renderer.run()

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test("modified value")
    func modifiedValue() {

      var output = ""

      let renderer = Renderer(canvas: TestCanvas(width: 3, height: 3)) {
        Text("x")
          .preference(key: PreferenceKey.A.self, value: "new")
          .fixedSize(horizontal: true, vertical: false)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }
      renderer.run()

      #expect(output == "new")
    }
  }
}
