
public struct Position: Equatable, Hashable {
  let x: Horizontal
  let y: Vertical

  public init(x: Horizontal, y: Vertical) {
    self.x = x
    self.y = y
  }
}

extension Position {
  var controlSequence: ControlSequence {
    "\(y);\(x)H"
  }
}
