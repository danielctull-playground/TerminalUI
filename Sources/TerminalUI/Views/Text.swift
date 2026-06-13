import AttributeGraph

public struct Text: PrimitiveView {

  private let string: String

  public init(_ string: String) {
    self.string = string
  }

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.constant(.empty),
      displayItems: inputs.graph.rule { _ in
        [
          DisplayItem { proposal in
            size(for: proposal, view: view, inputs: inputs)
          } render: { bounds in
            render(in: bounds, view: view, inputs: inputs)
          }
        ]
      }
    )
  }

  static private func size(
    for proposal: ProposedViewSize,
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> Size {
    let size = proposal.replacingUnspecifiedDimensions()
    let lines = inputs.graph[view].string.lines(ofLength: size.width)
    let height = lines.count
    let width = lines.map(\.count).max() ?? 0
    return Size(width: width, height: height)
  }

  static private func render(
    in bounds: Rect,
    view: Attribute<Self>,
    inputs: ViewInputs
  ) {

    let lines = inputs.graph[view].string.lines(ofLength: Int(bounds.size.width))
    let environment = inputs.graph[inputs.dynamicProperties.environment]

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
        inputs.canvas.draw(pixel, at: Position(x: x, y: y))
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
