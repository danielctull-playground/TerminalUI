
struct LayoutComputer {

  private let size: (ProposedViewSize) -> Size
  private let place: (Rect) -> Void
  let render: () -> DisplayList

  init(
    size: @escaping (ProposedViewSize) -> Size,
    place: @escaping (Rect) -> Void,
    render: @escaping () -> DisplayList
  ) {
    self.size = size
    self.place = place
    self.render = render
  }

  func size(for proposal: ProposedViewSize) -> Size {
    size(proposal)
  }

  func place(in frame: Rect) {
    place(frame)
  }
}
