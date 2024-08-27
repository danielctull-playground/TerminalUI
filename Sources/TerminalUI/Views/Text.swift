
public struct Text {

  @Environment(\.backgroundColor) private var backgroundColor
  @Environment(\.blinking) private var blinking
  @Environment(\.bold) private var bold
  @Environment(\.foregroundColor) private var foregroundColor
  @Environment(\.hidden) private var hidden
  @Environment(\.inverse) private var inverse
  @Environment(\.italic) private var italic
  @Environment(\.strikethrough) private var strikethrough
  @Environment(\.underline) private var underline

  private let string: String

  public init(_ string: String) {
    self.string = string
  }
}

extension Text: View {

  public var body: some View {
    BuiltinView { canvas in
      for (character, index) in zip(string, 1...) {
        let pixel = Pixel(
          character,
          foreground: foregroundColor,
          background: backgroundColor,
          bold: bold,
          italic: italic,
          underline: underline,
          blinking: blinking,
          inverse: inverse,
          hidden: hidden,
          strikethrough: strikethrough
        )
        canvas.draw(pixel, at: Position(x: index, y: 0))
      }
    }
  }
}
