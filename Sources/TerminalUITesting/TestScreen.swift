import TerminalUI
import Testing

public struct TestScreen: Screen {

  @Mutable private var _buffer = Buffer()
  @Mutable private var _csi: [CSI] = []
  private let bounds: Rect

  public init(width: Int, height: Int) {
    bounds = Rect(origin: .origin, size: Size(width: width, height: height))
  }

  public func send(_ csi: CSI) {
    _csi.append(csi)
  }

  public func draw(_ buffer: ScreenBuffer) {

    var cells: [Position: Cell] = [:]

    if bounds.size.width > 0, bounds.size.height > 0 {
      for x in bounds.minX...bounds.maxX {
        for y in bounds.minY...bounds.maxY {
          cells[Position(x: x, y: y)] = Cell.empty
        }
      }
    }

    for (position, cell) in buffer.cells {
      cells[position] = cell
    }

    _buffer = Buffer(cells: cells)
  }
}

extension TestScreen {

  package var buffer: Buffer {
    _buffer
  }

  public var cells: [Position: Cell] {
    _buffer.cells
  }

  public var csi: [CSI] {
    _csi
  }

  public func render(@ViewBuilder content: () -> some View) {
    render(size: bounds.size, content: content)
  }
}

extension TestScreen: CustomStringConvertible {

  public var description: String {

    let ys = (bounds.minY...bounds.maxY)
    let xs = (bounds.minX...bounds.maxX)

    var characters: [[Character]] = ys.map { _ in xs.map { _ in " " } }

    for (position, cell) in cells {
      guard ys.contains(position.y) && xs.contains(position.x) else { continue }
      let y = bounds.origin.y.distance(to: position.y)
      let x = bounds.origin.x.distance(to: position.x)
      characters[y][x] = cell.content
    }

    return characters
      .map { String($0) }
      .joined(separator: "\n")
  }
}
