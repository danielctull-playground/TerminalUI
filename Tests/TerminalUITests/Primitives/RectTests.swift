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

  @Test("union", arguments: Array<(Rect, Rect, Rect)>([
    // Same
    (Rect(x:1, y:2, w:3, h:4), Rect(x:1, y:2, w:3, h:4), Rect(x:1, y:2, w:3, h:4)),

    // Distinct
    (Rect(x:2, y:2, w:1, h:1), Rect(x:1, y:1, w:1, h:1), Rect(x:1, y:1, w:2, h:2)),
    (Rect(x:1, y:2, w:3, h:4), Rect(x:5, y:6, w:7, h:8), Rect(x:1, y:2, w:11, h:12)),

    // Intersect
    (Rect(x:1, y:1, w:1, h:1), Rect(x:1, y:1, w:2, h:2), Rect(x:1, y:1, w:2, h:2)),
  ]))
  func union(lhs: Rect, rhs: Rect, expected: Rect) {
    #expect(lhs.union(rhs) == expected)
    #expect(rhs.union(lhs) == expected)
  }
}

extension Rect {
  fileprivate init(x: Int, y: Int, w: Int, h: Int) {
    self.init(x: x, y: y, width: w, height: h)
  }
}
