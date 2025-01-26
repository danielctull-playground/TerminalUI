
public struct Rect: Equatable, Hashable {

  public let origin: Position
  public let size: Size

  public init(origin: Position, size: Size) {
    self.origin = origin
    self.size = size
  }
}

extension Rect: CustomStringConvertible {
  public var description: String {
    "Rect(x: \(origin.x), y: \(origin.y), width: \(size.width), height: \(size.height))"
  }
}

extension Rect {

  public init(x: Int, y: Int, width: Int, height: Int) {
    self.init(
      origin: Position(x: x, y: y),
      size: Size(width: width, height: height))
  }
}
