@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("FixedSize", .tags(.modifier))
struct FixedSizeTests {

  private let view = Color.blue
  private let cell = Cell(" ", background: .blue)

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Color.black.fixedSize().body
    }
  }

  @Test func `horizontal`() {

    let screen = TestScreen(width: 1, height: 1)
    screen.render {
      view.fixedSize(horizontal: true, vertical: false)
    }

    // The default length for a nil length in a proposed size is 10.
    #expect(screen.cells == [
      Position(x: -4, y: 1): cell,
      Position(x: -3, y: 1): cell,
      Position(x: -2, y: 1): cell,
      Position(x: -1, y: 1): cell,
      Position(x:  0, y: 1): cell,
      Position(x:  1, y: 1): cell,
      Position(x:  2, y: 1): cell,
      Position(x:  3, y: 1): cell,
      Position(x:  4, y: 1): cell,
      Position(x:  5, y: 1): cell,
    ])
  }

  @Test func `vertical`() {

    let screen = TestScreen(width: 1, height: 1)
    screen.render {
      view.fixedSize(horizontal: false, vertical: true)
    }

    // The default length for a nil length in a proposed size is 10.
    #expect(screen.cells == [
      Position(x: 1, y: -4): cell,
      Position(x: 1, y: -3): cell,
      Position(x: 1, y: -2): cell,
      Position(x: 1, y: -1): cell,
      Position(x: 1, y:  0): cell,
      Position(x: 1, y:  1): cell,
      Position(x: 1, y:  2): cell,
      Position(x: 1, y:  3): cell,
      Position(x: 1, y:  4): cell,
      Position(x: 1, y:  5): cell,
    ])
  }

  @Test func `both`() {

    let screen = TestScreen(width: 1, height: 1)
    screen.render {
      view.fixedSize(horizontal: true, vertical: true)
    }

    // The default length for a nil length in a proposed size is 10.
    #expect(screen.cells.count == 100)

    let xs = -4...5
    let ys = -4...5
    let positions = xs.flatMap { x in
      ys.map { y in
        Position(x: x, y: y)
      }
    }

    let expected = Dictionary(uniqueKeysWithValues: positions.map { ($0, cell) })
    #expect(screen.cells == expected)
  }

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Text("x")
          .fixedSize(horizontal: true, vertical: false)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Text("x")
          .preference(key: PreferenceKey.A.self, value: "new")
          .fixedSize(horizontal: true, vertical: false)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
