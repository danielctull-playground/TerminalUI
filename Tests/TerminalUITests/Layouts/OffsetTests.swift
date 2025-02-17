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
}
