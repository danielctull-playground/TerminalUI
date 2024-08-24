
public struct Text {

  @Environment(\.blinking) private var blinking
  @Environment(\.bold) private var bold
  @Environment(\.inverse) private var inverse
  @Environment(\.italic) private var italic
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
          bold: bold,
          italic: italic,
          underline: underline,
          blinking: blinking,
          inverse: inverse
        )
        canvas.draw(pixel, at: Position(x: index, y: 0))
      }
    }
  }
}
