
public struct Size: Equatable, Hashable, Sendable {

  public internal(set) var width: Int
  public internal(set) var height: Int

  public init(width: Int, height: Int) {
    self.width = width
    self.height = height
  }
}

extension Size {
  static var zero: Size { Size(width: 0, height: 0) }
}
