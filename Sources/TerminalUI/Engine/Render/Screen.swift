import AttributeGraph

@MainActor
package protocol Screen {
  func draw(_ buffer: Buffer)

  func send(_ csi: CSI)
}

// MARK: - Screen.Buffer

extension Screen {
  package typealias Buffer = ScreenBuffer
}

@MainActor
public struct ScreenBuffer {

  package private(set) var cells: [Position: Cell]

  package init(cells: [Position: Cell] = [:]) {
    self.cells = cells
  }

  mutating func set(_ cell: Cell, for position: Position) {
    cells[position] = cell
  }
}

extension ScreenBuffer: @MainActor ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (Position, Cell)...) {
    self.init(cells: Dictionary(uniqueKeysWithValues: elements))
  }
}

extension Screen.Buffer: @MainActor CustomStringConvertible {

  public var description: String {
""
//    let positions = cells.keys
//
//    guard
//      let maxX = positions.map(\.x).max(by: <),
//      let minX = positions.map(\.x).min(by: <),
//      let maxY = positions.map(\.y).max(by: <),
//      let minY = positions.map(\.y).min(by: <)
//    else {
//      return ""
//    }
//
//    let f = (minY...maxY).map { y in
//      (minX...maxX).map { x in
//
//        let cell = cells[Position(x: x, y: y)] ?? Cell(content: " ", style: .default)
//
//        return switch (cell.content, cell.style) {
//        case (" ", .default): "."
//        case (" ", .background(.red)): "▧"
//        case (" ", .background(.blue)): "▨"
//        case (" ", .background(.green)): "▤"
//        case (" ", .background(.yellow)): "▥"
//        case (" ", .background(.black)): "▩"
//        case (" ", .background(.white)): "▢"
//        case (" ", _): "?"
//        default: String(cell.content)
//        }
//      }
//      .joined()
//    }
//    .joined(separator: "\n")
  }
}

extension Style {

  @MainActor
  fileprivate static func background(_ color: Color) -> Style {
    Style(backgroundColor: color)
  }

}
