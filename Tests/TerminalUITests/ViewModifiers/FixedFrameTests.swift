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

  @Suite("EmptyView.fixedFrame", .tags(.emptyView))
  struct EmptyViewTests {

    @Test("render")
    func render() {
      let canvas = TestCanvas(width: 3, height: 3)
      EmptyView()
        .frame(width: 2, height: 2)
        ._render(in: canvas, size: Size(width: 3, height: 3))
      #expect(canvas.pixels == [:])
    }

    @Test("size")
    func size() {
      let size = EmptyView()
        .frame(width: 2, height: 2)
        ._size(for: ProposedSize(width: 100, height: 100))
      #expect(size == nil)
    }
  }
}
