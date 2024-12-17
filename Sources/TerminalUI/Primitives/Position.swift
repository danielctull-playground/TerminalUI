
public struct Position: Equatable, Hashable {
  package let x: Horizontal
  package let y: Vertical

  public init(x: Horizontal, y: Vertical) {
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
