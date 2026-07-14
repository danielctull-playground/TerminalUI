import AttributeGraph

package protocol Screen {
  func draw(_ buffer: Buffer)

  func send(_ csi: CSI)
}

extension Screen {
  package typealias Buffer = ScreenBuffer
}

public struct ScreenBuffer {

  package private(set) var cells: [Position: Cell]

  package init(cells: [Position: Cell] = [:]) {
    self.cells = cells
  }

  mutating func set(_ cell: Cell, for position: Position) {
    cells[position] = cell
  }
}

extension ScreenBuffer: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (Position, Cell)...) {
    self.init(cells: Dictionary(uniqueKeysWithValues: elements))
  }
}
