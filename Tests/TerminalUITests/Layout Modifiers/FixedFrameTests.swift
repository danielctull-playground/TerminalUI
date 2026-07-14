@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("FixedFrame", .tags(.modifier))
struct FixedFrameTests {

  private let screen = TestScreen(width: 3, height: 3)
  private let view = Color.blue
  private let cell = Cell(" ", background: .blue)

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Color.black.frame().body
    }
  }

  @Test func `width: nil, height: nil`() {

    screen.render {
      view.frame()
    }

    #expect(screen.cells == [
      Position(x: 1, y: 1): cell,
      Position(x: 2, y: 1): cell,
      Position(x: 3, y: 1): cell,
      Position(x: 1, y: 2): cell,
      Position(x: 2, y: 2): cell,
      Position(x: 3, y: 2): cell,
      Position(x: 1, y: 3): cell,
      Position(x: 2, y: 3): cell,
      Position(x: 3, y: 3): cell,
    ])
  }

  @Test func `width: 1, height: nil`() {

    screen.render {
      view.frame(width: 1)
    }

    #expect(screen.cells == [
      Position(x: 2, y: 1): cell,
      Position(x: 2, y: 2): cell,
      Position(x: 2, y: 3): cell,
    ])
  }

  @Test func `width: 2, height: nil`() {

    screen.render {
      view.frame(width: 2)
    }

    #expect(screen.cells == [
      Position(x: 1, y: 1): cell,
      Position(x: 1, y: 2): cell,
      Position(x: 1, y: 3): cell,
      Position(x: 2, y: 1): cell,
      Position(x: 2, y: 2): cell,
      Position(x: 2, y: 3): cell,
    ])
  }

  @Test func `width: nil, height: 1`() {

    screen.render {
      view.frame(height: 1)
    }

    #expect(screen.cells == [
      Position(x: 1, y: 2): cell,
      Position(x: 2, y: 2): cell,
      Position(x: 3, y: 2): cell,
    ])
  }

  @Test func `width: nil, height: 2`() {

    screen.render {
      view.frame(height: 2)
    }

    #expect(screen.cells == [
      Position(x: 1, y: 1): cell,
      Position(x: 2, y: 1): cell,
      Position(x: 3, y: 1): cell,
      Position(x: 1, y: 2): cell,
      Position(x: 2, y: 2): cell,
      Position(x: 3, y: 2): cell,
    ])
  }

  @Test func `width: 1, height: 1`() {

    screen.render {
      view.frame(width: 1, height: 1)
    }

    #expect(screen.cells == [
      Position(x: 2, y: 2): cell,
    ])
  }

  @Test func `width: 2, height: 2`() {

    screen.render {
      view.frame(width: 2, height: 2)
    }

    #expect(screen.cells == [
      Position(x: 1, y: 1): cell,
      Position(x: 2, y: 1): cell,
      Position(x: 1, y: 2): cell,
      Position(x: 2, y: 2): cell,
    ])
  }

  @Test func `nested`() {

    screen.render {
      view
        .frame(width: 1, height: 1)
        .frame(width: 3, height: 3)
    }

    #expect(screen.cells == [
      Position(x: 2, y: 2): cell,
    ])
  }

  @Test(arguments: Array<(Alignment, Position)>([
    (.topLeading,     Position(x: 1, y: 1)),
    (.top,            Position(x: 2, y: 1)),
    (.topTrailing,    Position(x: 3, y: 1)),
    (.leading,        Position(x: 1, y: 2)),
    (.center,         Position(x: 2, y: 2)),
    (.trailing,       Position(x: 3, y: 2)),
    (.bottomLeading,  Position(x: 1, y: 3)),
    (.bottom,         Position(x: 2, y: 3)),
    (.bottomTrailing, Position(x: 3, y: 3)),
  ]))
  func `alignment`(alignment: Alignment, position: Position) {

    screen.render {
      view
        .frame(width: 1, height: 1)
        .frame(width: 3, height: 3, alignment: alignment)
    }

    #expect(screen.cells == [position: cell])
  }

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Text("x")
          .frame(width: 1, height: 1)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Text("x")
          .preference(key: PreferenceKey.A.self, value: "new")
          .frame(width: 1, height: 1)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
