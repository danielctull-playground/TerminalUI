
public struct Cell: Equatable, Sendable {
  package let content: Character
  let style: Style
}

extension Cell {

  init(
    _ content: Character,
    foreground: Color = .default,
    background: Color = .default,
    bold: Bold = .off,
    italic: Italic = .off,
    underline: UnderlineStyle = .off,
    blinking: Blinking = .off,
    inverse: Inverse = .off,
    hidden: Hidden = .off,
    strikethrough: Strikethrough = .off
  ) {
    self.content = content
    self.style = Style(
      foregroundColor: foreground,
      backgroundColor: background,
      bold: bold,
      italic: italic,
      underline: underline,
      blinking: blinking,
      inverse: inverse,
      hidden: hidden,
      strikethrough: strikethrough,
    )
  }
}

extension Cell: CustomStringConvertible {
  public var description: String {
    "Cell(\"\(content)\")"
  }
}
