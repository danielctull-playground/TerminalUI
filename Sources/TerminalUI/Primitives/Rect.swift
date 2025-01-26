
public struct Rect: Equatable, Hashable, Sendable {

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

extension Rect {
  public var minX: Int { origin.x }
  public var midX: Int { origin.x + size.width / 2 }
  public var maxX: Int { origin.x + size.width - 1 }

  public var minY: Int { origin.y }
  public var midY: Int { origin.y + size.height / 2 }
  public var maxY: Int { origin.y + size.height - 1 }
}

extension Rect {
  public func union(_ other: Rect) -> Rect {
    let minX = min(minX, other.minX)
    let maxX = max(maxX, other.maxX)
    let minY = min(minY, other.minY)
    let maxY = max(maxY, other.maxY)
    return Rect(
      x: minX,
      y: minY,
      width: maxX - minX + 1,
      height: maxY - minY + 1)
  }
}
