
struct Style: Equatable {
  var rendition: [GraphicRendition]
}

extension EnvironmentValues {

  var style: Style {
    Style(rendition: [
      foregroundColor.foreground,
      backgroundColor.background,
      bold.graphicRendition,
      italic.graphicRendition,
      underline.graphicRendition,
      blinking.graphicRendition,
      inverse.graphicRendition,
      hidden.graphicRendition,
      strikethrough.graphicRendition,
    ])
  }
}
