import TerminalUI
import Testing

public struct TestScreen: Screen {

  @Mutable private var buffer = Buffer()
  private let bounds: Rect

  public init(width: Int, height: Int) {
    bounds = Rect(origin: .origin, size: Size(width: width, height: height))
  }

  public func draw(_ buffer: ScreenBuffer) {
    self.buffer = buffer
  }
}

extension TestScreen {

  public var cells: [Position: Cell] {
    buffer.cells
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
