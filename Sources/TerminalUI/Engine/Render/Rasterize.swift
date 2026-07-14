
extension Screen {
  
  /// Rasterizes a list of items to the screen.
  ///
  /// - Parameter displayList: The list of items to rasterize.
  func rasterize(_ displayList: DisplayList) {
    for item in displayList.items {
      switch item.content {
      case let .fill(style): fill(in: item.frame, with: style)
      case let .text(text, style): draw(text: text, in: item.frame, with: style)
      }
    }
  }

  private func fill(in frame: Rect, with style: Style) {
    guard frame.size.width > 0, frame.size.height > 0 else { return }
    for x in frame.minX...frame.maxX {
      for y in frame.minY...frame.maxY {
        draw(Cell(content: " ", style: style), at: Position(x: x, y: y))
      }
    }
  }

  private func draw(text: String, in frame: Rect, with style: Style) {
    guard frame.size.width > 0, frame.size.height > 0 else { return }
    let lines = text.lines(ofLength: frame.size.width)
    for (line, y) in zip(lines, frame.origin.y...) {
      for (character, x) in zip(line, frame.origin.x...) {
        let cell = Cell(content: character, style: style)
        draw(cell, at: Position(x: x, y: y))
      }
    }
  }
}
