@testable import TerminalUI
import TerminalUITesting
import Testing

extension CanvasTests {

  @Suite("Rasterize")
  struct RasterizeTests {

    @Test func `fill covers every cell of its frame`() {

      let style = Style(rendition: Pixel(" ", background: .red).graphicRendition)
      let list = DisplayList(items: [
        DisplayList.Item(
          frame: Rect(x: 1, y: 1, width: 2, height: 2),
          content: .fill(style))
      ])

      let canvas = TestCanvas(width: 0, height: 0)
      canvas.rasterize(list)

      #expect(canvas.pixels == [
        Position(x: 1, y: 1): Pixel(" ", background: .red),
        Position(x: 2, y: 1): Pixel(" ", background: .red),
        Position(x: 1, y: 2): Pixel(" ", background: .red),
        Position(x: 2, y: 2): Pixel(" ", background: .red),
      ])
    }

    @Test func `text lays characters left to right`() {

      let style = Style(rendition: Pixel(" ").graphicRendition)
      let list = DisplayList(items: [
        DisplayList.Item(
          frame: Rect(x: 2, y: 3, width: 3, height: 1),
          content: .text("hi", style))
      ])

      let canvas = TestCanvas(width: 0, height: 0)
      canvas.rasterize(list)

      #expect(canvas.pixels == [
        Position(x: 2, y: 3): Pixel("h"),
        Position(x: 3, y: 3): Pixel("i"),
      ])
    }

    @Test func `later items win on overlap`() {
      let red = Style(rendition: Pixel(" ", background: .red).graphicRendition)
      let blue = Style(rendition: Pixel(" ", background: .blue).graphicRendition)
      let list = DisplayList(items: [
        DisplayList.Item(frame: Rect(x: 1, y: 1, width: 1, height: 1), content: .fill(red)),
        DisplayList.Item(frame: Rect(x: 1, y: 1, width: 1, height: 1), content: .fill(blue)),
      ])

      let canvas = TestCanvas(width: 0, height: 0)
      canvas.rasterize(list)

      #expect(canvas.pixels == [
        Position(x: 1, y: 1): Pixel(" ", background: .blue),
      ])
    }

    @Test func `empty frames produce no cells`() {

      let style = Style(rendition: Pixel(" ").graphicRendition)
      let list = DisplayList(items: [
        DisplayList.Item(frame: Rect(x: 1, y: 1, width: 0, height: 5), content: .fill(style)),
        DisplayList.Item(frame: Rect(x: 1, y: 1, width: 5, height: 0), content: .text("hi", style)),
      ])

      let canvas = TestCanvas(width: 0, height: 0)
      canvas.rasterize(list)

      #expect(canvas.pixels.isEmpty)
    }
  }
}
