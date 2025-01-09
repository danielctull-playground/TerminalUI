
public struct Position: Equatable, Hashable, Sendable {
  package let x: InfinityInt
  package let y: InfinityInt

  public init(x: InfinityInt, y: InfinityInt) {
    self.x = x
    self.y = y
  }
}

extension Position {
  package static var origin: Position { Position(x: 1, y: 1) }
}

extension Position {
  var controlSequence: ControlSequence {
    "\(y);\(x)H"
  }
}
