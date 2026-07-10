
struct LayoutProxy {

  private let size: (ProposedViewSize) -> Size
  private let place: (Rect) -> Void

  init(
    size: @escaping (ProposedViewSize) -> Size,
    place: @escaping (Rect) -> Void,
  ) {
    self.size = size
    self.place = place
  }

  func size(for proposal: ProposedViewSize) -> Size {
    size(proposal)
  }

  func place(in frame: Rect) {
    place(frame)
  }
}
