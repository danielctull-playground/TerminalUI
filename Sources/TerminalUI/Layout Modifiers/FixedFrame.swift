
extension View {

  public func frame(
    width: Int? = nil,
    height: Int? = nil,
    alignment: Alignment = .center
  ) -> some View {
    FixedFrame(
      content: self,
      width: width,
      height: height,
      alignment: alignment
    )
  }
}

private struct FixedFrame<Content: View>: View {

  let content: Content
  let width: Int?
  let height: Int?
  let alignment: Alignment

  var body: some View {
    fatalError("Body should never be called.")
  }

  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[FixedFrame] preference values") {
        Content.makeView(inputs: inputs.content).preferenceValues
      },
      displayItems: inputs.graph.attribute("[FixedFrame] display items") {
        Content
          .makeView(inputs: inputs.content)
          .displayItems
          .map { item in
            DisplayItem { proposal in
              var fallback: Size { proposal.replacingUnspecifiedDimensions() }
              let proposal = ProposedViewSize(
                width: inputs.node.width ?? fallback.width,
                height: inputs.node.height ?? fallback.height)
              let size = item.size(for: proposal)
              return Size(width: inputs.node.width ?? size.width, height: inputs.node.height ?? size.height)
            } render: { bounds in
              let parent = inputs.node.alignment.position(for: bounds.size)
              let size = item.size(for: ProposedViewSize(bounds.size))
              let child = inputs.node.alignment.position(for: size)
              let position = Position(
                x: bounds.origin.x + parent.x - child.x,
                y: bounds.origin.y + parent.y - child.y)
              item.render(in: Rect(origin: position, size: size))
            }
          }
      }
    )
  }
}
