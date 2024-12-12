
struct Position: Equatable, Hashable {
  let x: Horizontal
  let y: Vertical
}

extension ControlSequence {
  static func position(_ position: Position) -> ControlSequence {
    "\(position.y);\(position.x)H"
  }
}
