
public struct Color: Equatable {
  let foreground: ControlSequence
  let background: ControlSequence
}

// MARK: - ANSI colors

extension Color {
  public static var black: Color { ansi(foreground: 30, background: 40) }
  public static var red: Color { ansi(foreground: 31, background: 41) }
  public static var green: Color { ansi(foreground: 32, background: 42) }
  public static var yellow: Color { ansi(foreground: 33, background: 43) }
  public static var blue: Color { ansi(foreground: 34, background: 44) }
  public static var magenta: Color { ansi(foreground: 35, background: 45) }
  public static var cyan: Color { ansi(foreground: 36, background: 46) }
  public static var white: Color { ansi(foreground: 37, background: 47) }
  public static var `default`: Color { ansi(foreground: 39, background: 49) }
}

extension Color {
  private static func ansi(
    foreground: GraphicRendition,
    background: GraphicRendition
  ) -> Color {
    Color(
      foreground: .selectGraphicRendition(foreground),
      background: .selectGraphicRendition(background))
  }
}
