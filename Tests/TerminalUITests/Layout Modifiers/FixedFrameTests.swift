@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("FixedFrame", .tags(.modifier))
struct FixedFrameTests {

  private let canvas = TestCanvas(width: 3, height: 3)
  private let view = Color.blue
  private let pixel = Pixel(" ", background: .blue)

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Color.black.frame().body
    }
  }

  @Test func `width: nil, height: nil`() {

    canvas.render {
      view.frame()
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): pixel,
      Position(x: 2, y: 1): pixel,
      Position(x: 3, y: 1): pixel,
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
      Position(x: 1, y: 3): pixel,
      Position(x: 2, y: 3): pixel,
      Position(x: 3, y: 3): pixel,
    ])
  }

  @Test func `width: 1, height: nil`() {

    canvas.render {
      view.frame(width: 1)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 1): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 2, y: 3): pixel,
    ])
  }

  @Test func `width: 2, height: nil`() {

    canvas.render {
      view.frame(width: 2)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): pixel,
      Position(x: 1, y: 2): pixel,
      Position(x: 1, y: 3): pixel,
      Position(x: 2, y: 1): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 2, y: 3): pixel,
    ])
  }

  @Test func `width: nil, height: 1`() {

    canvas.render {
      view.frame(height: 1)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
    ])
  }

  @Test func `width: nil, height: 2`() {

    canvas.render {
      view.frame(height: 2)
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

  @Test func `width: 1, height: 1`() {

    canvas.render {
      view.frame(width: 1, height: 1)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 2): pixel,
    ])
  }

  @Test func `width: 2, height: 2`() {

    canvas.render {
      view.frame(width: 2, height: 2)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): pixel,
      Position(x: 2, y: 1): pixel,
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
    ])
  }

  @Test func `nested`() {

    canvas.render {
      view
        .frame(width: 1, height: 1)
        .frame(width: 3, height: 3)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 2): pixel,
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

    canvas.render {
      view
        .frame(width: 1, height: 1)
        .frame(width: 3, height: 3, alignment: alignment)
    }

    #expect(canvas.pixels == [position: pixel])
  }

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Text("x")
          .frame(width: 1, height: 1)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Text("x")
          .preference(key: PreferenceKey.A.self, value: "new")
          .frame(width: 1, height: 1)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
