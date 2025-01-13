
public struct Size: Equatable, Hashable {

  public let width: Int
  public let height: Int

  public init(width: Int, height: Int) {
    self.width = width
    self.height = height
  }
}

extension Size {
  static var zero: Size { Size(width: 0, height: 0) }
}
