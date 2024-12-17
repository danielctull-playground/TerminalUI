
public struct Text: Builtin, View {

  private let string: String

  public init(_ string: String) {
    self.string = string
  }

  func render(in canvas: any Canvas, size: Size, environment: EnvironmentValues) {
    let origin = Position.origin
    for (character, index) in zip(string, origin.x...) {
      let pixel = Pixel(
        character,
        foreground: environment.foregroundColor,
        background: environment.backgroundColor,
        bold: environment.bold,
        italic: environment.italic,
        underline: environment.underline,
        blinking: environment.blinking,
        inverse: environment.inverse,
        hidden: environment.hidden,
        strikethrough: environment.strikethrough
      )
      canvas.draw(pixel, at: Position(x: index, y: origin.y))
    }
  }
}
