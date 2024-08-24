
public struct Text {

  @Environment(\.bold) private var bold
  private let string: String

  public init(_ string: String) {
    self.string = string
  }
}

extension Text: View {

  public var body: some View {
    BuiltinView { canvas in
      for (character, index) in zip(string, 1...) {
        canvas.draw(Pixel(character, bold: bold), at: Position(x: index, y: 0))
      }
    }
  }
}
