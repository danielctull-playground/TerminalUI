
struct Position: Equatable, Hashable {
  let x: Horizontal
  let y: Vertical
}

extension Position {
  var controlSequence: ControlSequence {
    "\(y);\(x)H"
  }
}
