
extension View {

  public func fixedSize(
    horizontal: Bool = true,
    vertical: Bool = true
  ) -> some View {
    FixedSize(content: self, horizontal: horizontal, vertical: vertical)
  }
}

private struct FixedSize<Content: View>: Builtin, View {

  let content: Content
  let horizontal: Bool
  let vertical: Bool

  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(displayItems: Content.makeView(inputs: inputs.content).displayItems.map { item in
      DisplayItem { proposal in
        var proposal = proposal
        if inputs.node.horizontal { proposal.width = nil }
        if inputs.node.vertical { proposal.height = nil }
        return item.size(for: proposal)
      } render: { bounds in
        item.render(in: bounds)
      }
    })
  }
}
