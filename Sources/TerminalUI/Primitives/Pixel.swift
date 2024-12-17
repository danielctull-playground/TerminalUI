
public struct Pixel: Equatable {

  let content: Character
  let foreground: Color
  let background: Color
  let bold: Bold
  let italic: Italic
  let underline: Underline
  let blinking: Blinking
  let inverse: Inverse
  let hidden: Hidden
  let strikethrough: Strikethrough

  public init(
    _ content: Character,
    foreground: Color = .default,
    background: Color = .default
  ) {
    self.content = content
    self.foreground = foreground
    self.background = background
    self.bold = .off
    self.italic = .off
    self.underline = .off
    self.blinking = .off
    self.inverse = .off
    self.hidden = .off
    self.strikethrough = .off
  }

  init(
    _ content: Character,
    foreground: Color = .default,
    background: Color = .default,
    bold: Bold = .off,
    italic: Italic = .off,
    underline: Underline = .off,
    blinking: Blinking = .off,
    inverse: Inverse = .off,
    hidden: Hidden = .off,
    strikethrough: Strikethrough = .off
  ) {
    self.content = content
    self.foreground = foreground
    self.background = background
    self.bold = bold
    self.italic = italic
    self.underline = underline
    self.blinking = blinking
    self.inverse = inverse
    self.hidden = hidden
    self.strikethrough = strikethrough
  }
}
