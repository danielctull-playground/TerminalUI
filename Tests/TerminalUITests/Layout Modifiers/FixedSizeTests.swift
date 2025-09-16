@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("FixedSize", .tags(.modifier))
struct FixedSizeTests {

  private let view = Color.blue
  private let pixel = Pixel(" ", background: .blue)

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Color.black.fixedSize().body
    }
  }

  @Test func `horizontal`() {

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

  @Test func `vertical`() {

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

  @Test func `both`() {

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

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Text("x")
          .fixedSize(horizontal: true, vertical: false)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Text("x")
          .preference(key: PreferenceKey.A.self, value: "new")
          .fixedSize(horizontal: true, vertical: false)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
