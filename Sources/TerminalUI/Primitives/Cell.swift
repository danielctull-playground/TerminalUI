
public struct Cell: Equatable, Sendable {

  package let content: Character
  let style: Style
}

extension Cell {

  public init(
    _ content: Character,
    foreground: Color = .default,
    background: Color = .default
  ) {
    self.init(
      content,
      foreground: foreground,
      background: background,
      bold: .off,
      italic: .off,
      underline: .off,
      blinking: .off,
      inverse: .off,
      hidden: .off,
      strikethrough: .off)
  }

  init(
    _ content: Character,
    foreground: Color = .default,
    background: Color = .default,
    bold: Bold,
    italic: Italic,
    underline: UnderlineStyle,
    blinking: Blinking,
    inverse: Inverse,
    hidden: Hidden,
    strikethrough: Strikethrough
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
