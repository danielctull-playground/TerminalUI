
public struct Position: Equatable, Hashable, Sendable {
  package let x: Int
  package let y: Int

  public init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

extension Position {
  package static var origin: Position { Position(x: 1, y: 1) }
}

extension Position {
  var csi: CSI {
    CSI(parameters: [CSI.Parameter(y), CSI.Parameter(x)], command: "H")
  }
}

extension Position: CustomStringConvertible {
  public var description: String {
    "Position(x: \(x), y: \(y))"
  }
}
