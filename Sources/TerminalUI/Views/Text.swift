
public struct Text: Builtin, View {

  private let string: String

  public init(_ string: String) {
    self.string = string
  }

  func size(
    for proposedSize: ProposedSize,
    environment: EnvironmentValues
  ) -> Size {
    Size(proposedSize)
  }

  func render(in canvas: any Canvas, size: Size, environment: EnvironmentValues) {

    let origin = Position.origin
    let xs = origin.x...size.width
    let lines = string.lines(ofLength: xs.count)

    for (line, y) in zip(lines, origin.y...) {
      for (character, x) in zip(line, origin.x...) {
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
        canvas.draw(pixel, at: Position(x: x, y: y))
      }
    }
  }
}

extension StringProtocol {

  fileprivate func lines(ofLength lineLength: Int) -> [SubSequence] {

    guard count > lineLength else {
      return [self[startIndex..<endIndex]]
    }

    let head: SubSequence
    let tail: SubSequence
    if dropFirst(lineLength).first == " " {
      let space = index(startIndex, offsetBy: lineLength)
      head = self[..<space]
      tail = self[index(after: space)...]
    } else if let space = dropLast(count - lineLength).lastIndex(of: " ") {
      head = self[..<space]
      tail = self[index(after: space)...]
    } else {
      let end = index(startIndex, offsetBy: lineLength)
      head = self[..<end]
      tail = self[end...]
    }

    return [head] + tail.lines(ofLength: lineLength)
  }
}
