
public struct Size {

  public let width: InfinityInt
  public let height: InfinityInt

  public init(width: InfinityInt, height: InfinityInt) {
    self.width = width
    self.height = height
  }
}

extension Size {
  static var zero: Size { Size(width: 0, height: 0) }
}
