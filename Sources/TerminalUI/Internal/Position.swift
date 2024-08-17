
struct Position: Equatable, Hashable {
  let x: Int
  let y: Int
}

extension Position {
  var controlSequence: ControlSequence { "\(y);\(x)H" }
}
