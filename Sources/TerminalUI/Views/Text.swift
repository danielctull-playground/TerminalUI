
public struct Text {

  private let string: String

  public init(_ string: String) {
    self.string = string
  }
}

extension Text: View {

  public var body: some View {
    BuiltinView { canvas in
      for (character, index) in zip(string, 1...) {
        canvas.draw(Pixel(character), at: Position(x: index, y: 0))
      }
    }
  }
}
