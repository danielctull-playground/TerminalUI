
struct Style: Equatable {
  let foregroundColor: Color
  let backgroundColor: Color
  let bold: Bold
  let italic: Italic
  let underline: UnderlineStyle
  let blinking: Blinking
  let inverse: Inverse
  let hidden: Hidden
  let strikethrough: Strikethrough

  init(
    foregroundColor: Color = .default,
    backgroundColor: Color = .default,
    bold: Bold = .off,
    italic: Italic = .off,
    underline: UnderlineStyle = .off,
    blinking: Blinking = .off,
    inverse: Inverse = .off,
    hidden: Hidden = .off,
    strikethrough: Strikethrough = .off
  ) {
    self.foregroundColor = foregroundColor
    self.backgroundColor = backgroundColor
    self.bold = bold
    self.italic = italic
    self.underline = underline
    self.blinking = blinking
    self.inverse = inverse
    self.hidden = hidden
    self.strikethrough = strikethrough
  }
}

extension Style {
  var graphicRendition: [GraphicRendition] {
    [
      foregroundColor.foreground,
      backgroundColor.background,
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

extension EnvironmentValues {

  var style: Style {
    Style(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
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
