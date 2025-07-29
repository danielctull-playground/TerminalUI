
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

private struct FixedFrame<Content: View>: Builtin, View {

  let content: Content
  let width: Int?
  let height: Int?
  let alignment: Alignment

  func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(displayItems: content.makeView(inputs: inputs.content).displayItems.map { item in
      DisplayItem { proposal in
        var fallback: Size { proposal.replacingUnspecifiedDimensions() }
        let proposal = ProposedViewSize(
          width: width ?? fallback.width,
          height: height ?? fallback.height)
        let size = item.size(for: proposal)
        return Size(width: width ?? size.width, height: height ?? size.height)
      } render: { bounds in
        let parent = alignment.position(for: bounds.size)
        let size = item.size(for: ProposedViewSize(bounds.size))
        let child = alignment.position(for: size)
        let position = Position(
          x: bounds.origin.x + parent.x - child.x,
          y: bounds.origin.y + parent.y - child.y)
        item.render(in: Rect(origin: position, size: size))
      }
    })
  }
}
