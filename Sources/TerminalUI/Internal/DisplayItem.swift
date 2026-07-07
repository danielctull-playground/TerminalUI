
struct DisplayItem {
  private let size: (ProposedViewSize) -> Size
  private let render: (Rect) -> DisplayList

  init(
    size: @escaping (ProposedViewSize) -> Size,
    render: @escaping (Rect) -> DisplayList
  ) {
    self.size = size
    self.render = render
  }

  func size(for proposal: ProposedViewSize) -> Size {
    size(proposal)
  }

  func render(in bounds: Rect) -> DisplayList {
    guard bounds.size.height > 0 else { return [] }
    guard bounds.size.width > 0 else { return [] }
    return render(bounds)
  }
}
