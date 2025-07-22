
struct DisplayItem {
  private let size: (ProposedViewSize) -> Size
  private let render: (Rect) -> Void

  init(
    size: @escaping (ProposedViewSize) -> Size,
    render: @escaping (Rect) -> Void
  ) {
    self.size = size
    self.render = render
  }

  func size(for proposal: ProposedViewSize) -> Size {
    size(proposal)
  }

  func render(in bounds: Rect) {
    render(bounds)
  }
}
