
extension View {

  public func fixedSize(
    horizontal: Bool = true,
    vertical: Bool = true
  ) -> some View {
    FixedSize(content: self, horizontal: horizontal, vertical: vertical)
  }
}

private struct FixedSize<Content: View>: View {

  let content: Content
  let horizontal: Bool
  let vertical: Bool

  var body: some View {
    fatalError("Body should never be called.")
  }

  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    let content = Content.makeView(inputs: inputs.content).displayItems
    return ViewOutputs(displayItems: content.map { item in
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
