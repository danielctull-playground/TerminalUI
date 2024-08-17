
public struct Color: Equatable {
  let foreground: String
  let background: String
}

// MARK: - ANSI colors

extension Color {
  public static let black = ansi(foreground: 30, background: 40)
  public static let red = ansi(foreground: 31, background: 41)
  public static let green = ansi(foreground: 32, background: 42)
  public static let yellow = ansi(foreground: 33, background: 43)
  public static let blue = ansi(foreground: 34, background: 44)
  public static let magenta = ansi(foreground: 35, background: 45)
  public static let cyan = ansi(foreground: 36, background: 46)
  public static let white = ansi(foreground: 37, background: 47)
  public static let `default` = ansi(foreground: 39, background: 49)
}

extension Color {
  private static func ansi(foreground: Int, background: Int) -> Color {
    Color(
      foreground: "\u{1b}[\(foreground)m",
      background: "\u{1b}[\(background)m")
  }
}
