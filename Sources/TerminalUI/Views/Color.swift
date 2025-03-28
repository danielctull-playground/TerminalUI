
public struct Color: Builtin, CustomStringConvertible, Equatable, Sendable, View {
  public let description: String
  let foreground: ControlSequence
  let background: ControlSequence

  func size(
    for proposal: ProposedViewSize,
    environment: EnvironmentValues
  ) -> Size {
    proposal.replacingUnspecifiedDimensions()
  }

  func render(in bounds: Rect, canvas: any Canvas, environment: EnvironmentValues) {
    let pixel = Pixel(" ", background: self)
    for x in bounds.minX...bounds.maxX {
      for y in bounds.minY...bounds.maxY {
        canvas.draw(pixel, at: Position(x: x, y: y))
      }
    }
  }
}

// MARK: - ANSI colors

extension Color {
  public static var black: Color { ansi(name: "black", foreground: 30, background: 40) }
  public static var red: Color { ansi(name: "red", foreground: 31, background: 41) }
  public static var green: Color { ansi(name: "green", foreground: 32, background: 42) }
  public static var yellow: Color { ansi(name: "yellow", foreground: 33, background: 43) }
  public static var blue: Color { ansi(name: "blue", foreground: 34, background: 44) }
  public static var magenta: Color { ansi(name: "magenta", foreground: 35, background: 45) }
  public static var cyan: Color { ansi(name: "cyan", foreground: 36, background: 46) }
  public static var white: Color { ansi(name: "white", foreground: 37, background: 47) }
  public static var `default`: Color { ansi(name: "default", foreground: 39, background: 49) }
}

extension Color {
  private static func ansi(
    name: String,
    foreground: GraphicRendition,
    background: GraphicRendition
  ) -> Color {
    Color(
      description: "ansi(\(name))",
      foreground: .selectGraphicRendition(foreground),
      background: .selectGraphicRendition(background))
  }
}
