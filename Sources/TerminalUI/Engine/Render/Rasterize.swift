
extension Screen {
  
  /// Rasterizes a list of items to the screen.
  ///
  /// - Parameter displayList: The list of items to rasterize.
  func rasterize(_ displayList: DisplayList) {

    var buffer = Buffer()

    for item in displayList.items {
      switch item.content {
      case let .fill(style): fill(in: &buffer, frame: item.frame, style: style)
      case let .text(text, style): draw(in: &buffer, text: text, frame: item.frame, style: style)
      }
    }

    draw(buffer)
  }

  private func fill(in buffer: inout Buffer, frame: Rect, style: Style) {
    guard frame.size.width > 0, frame.size.height > 0 else { return }
    for x in frame.minX...frame.maxX {
      for y in frame.minY...frame.maxY {
        buffer.set(Cell(content: " ", style: style), for: Position(x: x, y: y))
      }
    }
  }

  private func draw(in buffer: inout Buffer, text: String, frame: Rect, style: Style) {
    guard frame.size.width > 0, frame.size.height > 0 else { return }
    let lines = text.lines(ofLength: frame.size.width)
    for (line, y) in zip(lines, frame.origin.y...) {
      for (character, x) in zip(line, frame.origin.x...) {
        buffer.set(Cell(content: character, style: style), for: Position(x: x, y: y))
      }
    }
  }
}
