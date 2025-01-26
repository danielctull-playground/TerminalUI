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

  @Test("minX")
  func minX() {
    #expect(Rect(x: 1, y: 2, width: 3, height: 4).minX == 1)
    #expect(Rect(x: 5, y: 6, width: 7, height: 8).minX == 5)
  }

  @Test("midX")
  func midX() {
    #expect(Rect(x: 1, y: 2, width: 4, height: 4).midX == 3)
    #expect(Rect(x: 5, y: 6, width: 7, height: 8).midX == 8)
  }

  @Test("maxX")
  func maxX() {
    #expect(Rect(x: 1, y: 2, width: 3, height: 4).maxX == 3)
    #expect(Rect(x: 5, y: 6, width: 7, height: 8).maxX == 11)
  }

  @Test("minY")
  func minY() {
    #expect(Rect(x: 1, y: 2, width: 4, height: 4).minY == 2)
    #expect(Rect(x: 5, y: 6, width: 7, height: 8).minY == 6)
  }

  @Test("midY")
  func midY() {
    #expect(Rect(x: 1, y: 2, width: 4, height: 4).midY == 4)
    #expect(Rect(x: 5, y: 6, width: 7, height: 8).midY == 10)
  }

  @Test("maxY")
  func maxY() {
    #expect(Rect(x: 1, y: 2, width: 4, height: 4).maxY == 5)
    #expect(Rect(x: 5, y: 6, width: 7, height: 8).maxY == 13)
  }
}
