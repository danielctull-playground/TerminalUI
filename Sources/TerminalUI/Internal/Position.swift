
struct Position: Equatable, Hashable {
  let x: Int
  let y: Int
}

extension ControlSequence {
  static func position(_ position: Position) -> ControlSequence {
    "\(position.y);\(position.x)H"
  }
}
