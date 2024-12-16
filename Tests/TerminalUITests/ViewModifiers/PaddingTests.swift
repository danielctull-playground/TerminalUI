@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Padding", .tags(.viewModifier))
struct PaddingTests {

  let canvas = TestCanvas()
  let view = Color.blue
  let pixel = Pixel(" ", background: .blue)

  @Test("edge insets")
  func edgeInsets() {

    canvas.render(size: Size(width: 8, height: 6)) {
      view.padding(EdgeInsets(top: 1, leading: 2, bottom: 3, trailing: 4))
    }

    #expect(canvas.pixels == [
      Position(x: 3, y: 2): pixel,
      Position(x: 4, y: 2): pixel,
      Position(x: 3, y: 3): pixel,
      Position(x: 4, y: 3): pixel,
    ])
  }

  @Test("all")
  func all() async throws {

    canvas.render(size: Size(width: 3, height: 3)) {
      view.padding(.all, 1)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 2): pixel,
    ])
  }

  @Test("top")
  func top() async throws {

    canvas.render(size: Size(width: 3, height: 3)) {
      view.padding(.top, 1)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
      Position(x: 1, y: 3): pixel,
      Position(x: 2, y: 3): pixel,
      Position(x: 3, y: 3): pixel,
    ])
  }

  @Test("leading")
  func leading() async throws {

    canvas.render(size: Size(width: 3, height: 3)) {
      view.padding(.leading, 1)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 1): pixel,
      Position(x: 3, y: 1): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
      Position(x: 2, y: 3): pixel,
      Position(x: 3, y: 3): pixel,
    ])
  }

  @Test("bottom")
  func bottom() async throws {

    canvas.render(size: Size(width: 3, height: 3)) {
      view.padding(.bottom, 1)
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

  @Test("trailing")
  func trailing() async throws {

    canvas.render(size: Size(width: 3, height: 3)) {
      view.padding(.trailing, 1)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): pixel,
      Position(x: 2, y: 1): pixel,
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 1, y: 3): pixel,
      Position(x: 2, y: 3): pixel,
    ])
  }

  @Test("horizontal")
  func horizontal() async throws {

    canvas.render(size: Size(width: 3, height: 3)) {
      view.padding(.horizontal, 1)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 1): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 2, y: 3): pixel,
    ])
  }

  @Test("vertical")
  func vertical() async throws {

    canvas.render(size: Size(width: 3, height: 3)) {
      view.padding(.vertical, 1)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
    ])
  }

  @Test("length")
  func length() async throws {

    canvas.render(size: Size(width: 4, height: 4)) {
      view.padding(1)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
      Position(x: 2, y: 3): pixel,
      Position(x: 3, y: 3): pixel,
    ])
  }
}
