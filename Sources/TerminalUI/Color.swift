
public struct Color: CustomStringConvertible, Equatable, Sendable {
  public let description: String
  let foreground: ControlSequence
  let background: ControlSequence
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
