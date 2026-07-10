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

    unowned let graph = inputs.graph
    let geometry = graph.external(of: ViewGeometry.self)

    return ViewOutputs(
      preferenceValues: inputs.graph.constant(.empty),
      layoutComputers: inputs.graph.rule { _ in
        [
          LayoutComputer { proposal in
            size(for: proposal, view: view, inputs: inputs)
          } place: { frame in
            graph.setValue(of: geometry, to: ViewGeometry(frame: frame))
          } render: {

            let frame = graph[geometry].frame
            let string = graph[view].string
            let style = graph[inputs.environment].style

            return DisplayList(items: [
              DisplayList.Item(frame: frame, content: .text(string, style))
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
