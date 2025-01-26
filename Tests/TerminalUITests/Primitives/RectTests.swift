import TerminalUI
import Testing

@Suite("Rect") struct RectTests {

  @Test("init(origin:size:)")
  func init_origin_size() {
    let x = Int.random
    let y = Int.random
    let width = Int.random
    let height = Int.random
    let rect = Rect(
      origin: Position(x: x, y: y),
      size: Size(width: width, height: height))
    #expect(rect.origin.x == x)
    #expect(rect.origin.y == y)
    #expect(rect.size.width == width)
    #expect(rect.size.height == height)
  }

  @Test("init(x:y:width:height:)")
  func init_x_y_width_height() {
    let x = Int.random
    let y = Int.random
    let width = Int.random
    let height = Int.random
    let rect = Rect(x: x, y: y, width: width, height: height)
    #expect(rect.origin.x == x)
    #expect(rect.origin.y == y)
    #expect(rect.size.width == width)
    #expect(rect.size.height == height)
  }

  @Test("description")
  func description() {
    let rect = Rect(x: 1, y: 2, width: 3, height: 4)
    #expect(rect.description == "Rect(x: 1, y: 2, width: 3, height: 4)")
  }
}
