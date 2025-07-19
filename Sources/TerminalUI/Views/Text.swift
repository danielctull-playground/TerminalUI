
public struct Text {

  private let string: String

  public init(_ string: String) {
    self.string = string
  }
}

extension Text: View {

  public var body: some View {
    fatalError()
  }

  public static func _makeView(_ inputs: ViewInputs<Text>) -> ViewOutputs {
    let layoutComputer = inputs.graph.attribute("Layout Computer") {
      LayoutComputer(sizeThatFits: inputs.node.size, childGeometries: { [$0] })
    }

    let displayList = inputs.graph.attribute("Display List") {
      DisplayList(items: [
        DisplayList.Item(name: "item") { canvas in
          inputs.node.render(in: inputs.frame, canvas: canvas, environment: inputs.environment)
        }
      ])
    }

    return ViewOutputs(layoutComputer: layoutComputer, displayList: displayList)
  }

  private func size(
    for proposal: ProposedViewSize
  ) -> Size {
    let size = proposal.replacingUnspecifiedDimensions()
    let lines = string.lines(ofLength: size.width)
    let height = lines.count
    let width = lines.map(\.count).max() ?? 0
    return Size(width: width, height: height)
  }

  func render(in bounds: Rect, canvas: any Canvas, environment: EnvironmentValues) {

    let lines = string.lines(ofLength: Int(bounds.size.width))

    for (line, y) in zip(lines, bounds.origin.y...) {
      for (character, x) in zip(line, bounds.origin.x...) {
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

    guard lineLength > 0 else { return [] }
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
