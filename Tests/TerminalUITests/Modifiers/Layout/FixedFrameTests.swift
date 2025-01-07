import TerminalUI
import TerminalUITesting
import Testing

@Suite("FixedFrame", .tags(.viewModifier))
struct FixedFrameTests {

  private let canvas = TestCanvas(width: 3, height: 3)
  private let view = Color.blue
  private let pixel = Pixel(" ", background: .blue)

  @Test("width: nil, height: nil")
  func widthNil_heightNil() {

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

  @Test("width: 1, height: nil")
  func width1_heightNil() {

    canvas.render {
      view.frame(width: 1)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 1): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 2, y: 3): pixel,
    ])
  }

  @Test("width: 2, height: nil")
  func width2_heightNil() {

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

  @Test("width: nil, height: 1")
  func widthNil_height1() {

    canvas.render {
      view.frame(height: 1)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
    ])
  }

  @Test("width: nil, height: 2")
  func widthNil_height2() {

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

  @Test("width: 1, height: 1")
  func width1_height1() {

    canvas.render {
      view.frame(width: 1, height: 1)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 2): pixel,
    ])
  }

  @Test("width: 2, height: 2")
  func width2_height2() {

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

  @Test("nested")
  func nested() {

    canvas.render {
      view
        .frame(width: 1, height: 1)
        .frame(width: 3, height: 3)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 2): pixel,
    ])
  }

  @Test("alignment", arguments: Array<(Alignment, Position)>([
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
  func alignment(alignment: Alignment, position: Position) {

    canvas.render {
      view
        .frame(width: 1, height: 1)
        .frame(width: 3, height: 3, alignment: alignment)
    }

    #expect(canvas.pixels == [position: pixel])
  }
}
