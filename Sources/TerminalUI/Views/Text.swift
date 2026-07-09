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

            let string = inputs.graph[view].string
            let style = inputs.graph[inputs.environment].style

            return DisplayList(items: [
              DisplayList.Item(frame: bounds, content: .text(string, style))
            ])
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
}
