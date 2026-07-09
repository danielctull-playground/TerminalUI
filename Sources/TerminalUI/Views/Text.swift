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
    let environment = inputs.graph[inputs.environment]

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
