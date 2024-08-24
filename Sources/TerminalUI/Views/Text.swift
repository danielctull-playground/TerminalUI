
public struct Text {

  @Environment(\.bold) private var bold
  @Environment(\.italic) private var italic

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
          italic: italic
        )
        canvas.draw(pixel, at: Position(x: index, y: 0))
      }
    }
  }
}
