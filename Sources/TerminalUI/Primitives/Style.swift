
struct Style: Equatable {
  var graphicRendition: [GraphicRendition]
}

extension EnvironmentValues {

  var style: Style {
    Style(graphicRendition: [
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
