
extension Canvas {
  
  /// Rasterizes a list of items to the canvas.
  ///
  /// - Parameter displayList: The list of items to rasterize.
  func rasterize(_ displayList: DisplayList) {
    var cells: [Position: Cell] = [:]
    for item in displayList.items {
      switch item.content {
      case let .fill(style): fill(in: &cells, frame: item.frame, style: style)
      case let .text(text, style): draw(in: &cells, text: text, frame: item.frame, style: style)
      }
    }
  }

  private func fill(
    in cells: inout [Position: Cell],
    frame: Rect,
    style: Style
  ) {
    guard frame.size.width > 0, frame.size.height > 0 else { return }
    for x in frame.minX...frame.maxX {
      for y in frame.minY...frame.maxY {
        cells[Position(x: x, y: y)] = Cell(content: " ", style: style)
      }
    }
  }

  private func draw(
    in cells: inout [Position: Cell],
    text: String,
    frame: Rect,
    style: Style
  ) {
    guard frame.size.width > 0, frame.size.height > 0 else { return }
    let lines = text.lines(ofLength: frame.size.width)
    for (line, y) in zip(lines, frame.origin.y...) {
      for (character, x) in zip(line, frame.origin.x...) {
        cells[Position(x: x, y: y)] = Cell(content: character, style: style)
      }
    }
  }
}
