
public struct Pixel: Equatable, Sendable {

  package let content: Character
  let graphicRendition: [GraphicRendition]

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
    self.graphicRendition = [
      foreground.foreground,
      background.background,
      bold.graphicRendition,
      italic.graphicRendition,
      underline.graphicRendition,
      blinking.graphicRendition,
      inverse.graphicRendition,
      hidden.graphicRendition,
      strikethrough.graphicRendition,
    ]
  }
}
