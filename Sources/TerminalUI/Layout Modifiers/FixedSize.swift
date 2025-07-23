
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

  func displayItems(inputs: ViewInputs) -> [DisplayItem] {
    content.displayItems(inputs: inputs).map { item in
      DisplayItem { proposal in
        var proposal = proposal
        if horizontal { proposal.width = nil }
        if vertical { proposal.height = nil }
        return item.size(for: proposal)
      } render: { bounds in
        item.render(in: bounds)
      }
    }
  }
}
