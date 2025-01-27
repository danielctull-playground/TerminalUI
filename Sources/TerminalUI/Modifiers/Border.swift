
extension View {

  public func border() -> some View {
    Border(content: self, style: .rounded)
  }
}

private struct BorderStyle {
  let topLeading: Character
  let top: Character
  let topTrailing: Character
  let leading: Character
  let trailing: Character
  let bottomLeading: Character
  let bottom: Character
  let bottomTrailing: Character

  init(
    _ topLeading: Character,
    _ top: Character,
    _ topTrailing: Character,
    _ leading: Character,
    _ trailing: Character,
    _ bottomLeading: Character,
    _ bottom: Character,
    _ bottomTrailing: Character
  ) {
    self.topLeading = topLeading
    self.top = top
    self.topTrailing = topTrailing
    self.leading = leading
    self.trailing = trailing
    self.bottomLeading = bottomLeading
    self.bottom = bottom
    self.bottomTrailing = bottomTrailing
  }
}

extension BorderStyle {
  static var rounded: BorderStyle {
    BorderStyle("╭", "─", "╮",
                "│",      "│",
                "╰", "─", "╯")
  }
}

private struct Border<Content: View>: Builtin, View {

  let content: Content
  let style: BorderStyle

  func size(
    for proposal: ProposedViewSize,
    environment: EnvironmentValues
  ) -> Size {
    let proposal = ProposedViewSize(
      width: proposal.width.map { $0 - 2 },
      height: proposal.height.map { $0 - 2 })
    let size = content._size(for: proposal, environment: environment)
    return Size(width: size.width + 2, height: size.height + 2)
  }

  func render(
    in canvas: any Canvas,
    size: Size,
    environment: EnvironmentValues
  ) {

    let minX = Position.origin.x
    let minY = Position.origin.y
    let maxX = minX + size.width - 1
    let maxY = minY + size.height - 1

    canvas.draw(Pixel(style.topLeading), at: Position(x: minX, y: minY))
    canvas.draw(Pixel(style.topTrailing), at: Position(x: maxX, y: minY))
    canvas.draw(Pixel(style.bottomLeading), at: Position(x: minX, y: maxY))
    canvas.draw(Pixel(style.bottomTrailing), at: Position(x: maxX, y: maxY))

    for x in minX+1..<maxX {
      canvas.draw(Pixel(style.top), at: Position(x: x, y: minY))
      canvas.draw(Pixel(style.bottom), at: Position(x: x, y: maxY))
    }

    for y in minY+1..<maxY {
      canvas.draw(Pixel(style.leading), at: Position(x: minX, y: y))
      canvas.draw(Pixel(style.trailing), at: Position(x: maxX, y: y))
    }

    content._render(
      in: canvas.translateBy(x: 1, y: 1),
      size: Size(width: size.width - 2, height: size.height - 2),
      environment: environment
    )
  }
}
